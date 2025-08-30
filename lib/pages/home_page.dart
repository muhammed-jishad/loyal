import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_new_app/pages/widgets/home_carousel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api.dart/api.dart';
import '../api.dart/service.dart';
import '../common/shared_class.dart';
import '../common/theme_helper.dart';
import '../modal/model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Branch> branches = [];
  String? selectedBranchCode;
  List<Flyer> flyers = [];
  final List<String> imgList = [
    'abc.jpg',
    'abc.jpg',
    'abc.jpg',
    'abc.jpg',
    'av.jpg',
    'as.jpg',
  ];
  Future<List<String>> fetchBannerImages() async {
    final response = await get(Uri.parse('${api}banners'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final banners = data['data'] as List;
      return banners
          .map<String>((banner) => banner['ban_image'] as String)
          .toList();
    } else {
      throw Exception('Failed to load banners');
    }
  }

  late List<Widget> imageSliders;
  String baseUrl = '${flyerpathup}/';

  var _custName;
  @override
  void initState() {
    super.initState();

    imageSliders = imgList
        .map(
          (item) => ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Image.network(
              '$baseUrl$item',
              fit: BoxFit
                  .cover, // Ensures the image covers the space without extra padding
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) =>
                  Center(child: Icon(Icons.broken_image)),
            ),
          ),
        )
        .toList();

    _fetchBranches();
    _loadCustomerName();
  }

  Future<void> _loadCustomerName() async {
    setState(() {
      _custName = AppPreferences.prefs.getString('name') ?? "Guest";
    });
  }

  Future<void> _fetchBranches() async {
    branches = await BranchService.fetchBranches();
    setState(() {});
  }

  Future<void> _fetchFlyers(String branchCode) async {
    flyers = await BranchService.fetchFlyers(branchCode);
    setState(() {});
  }

  void _openFlyer(String flyerPath) async {
    final url = '$flyerpathup/$flyerPath';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    child: DropdownButtonFormField<String>(
                      decoration: ThemeHelper().textInputDecoration(
                        "Store",
                        "Select a store",
                      ),
                      borderRadius: BorderRadius.circular(20),
                      value: selectedBranchCode,
                      items: branches.map((branch) {
                        return DropdownMenuItem<String>(
                          value: branch.code.toString(),
                          child: Text(branch.description),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBranchCode = value;
                          if (value != null) {
                            _fetchFlyers(value);
                          }
                        });
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please select a branch';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    child: Text.rich(
                      TextSpan(
                        text: "Hello ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: _custName,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 120,
              width: double
                  .infinity, // Ensures it spans the full width of the screen
              margin: EdgeInsets.zero, // Removes margin around the container
              padding: EdgeInsets.zero,
              child: FutureBuilder<List<String>>(
                future: fetchBannerImages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error loading banners'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No banners available'));
                  } else {
                    return BannerCarousel(imageUrls: snapshot.data!);
                  }
                },
              ),
            ),
            SizedBox(height: 5),
            flyers.length ==
                    1 // Check if the number of flyers is odd
                ? ListView.builder(
                    shrinkWrap:
                        true, // Ensures it doesn't take up unnecessary space
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: flyers.length,
                    itemBuilder: (context, index) {
                      final flyer = flyers[index];
                      return _buildFlyerCard(
                        context,
                        flyer,
                      ); // Extracted for reuse
                    },
                  )
                : GridView.builder(
                    shrinkWrap:
                        true, // Ensures it doesn't take up unnecessary space
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Two items per row
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                          childAspectRatio: 1 / 1.2, // Adjust as needed
                        ),
                    itemCount: flyers.length,
                    itemBuilder: (context, index) {
                      final flyer = flyers[index];
                      return _buildFlyerCardgrid(
                        context,
                        flyer,
                      ); // Same card layout
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlyerCard(BuildContext context, Flyer flyer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.4),
                  Theme.of(context).hintColor.withOpacity(0.4),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.8),
                width: 2.5,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: InkWell(
              onTap: () => _openFlyer(flyer.path),
              child: Column(
                children: [
                  Image.network(
                    height: 375,
                    width: double.infinity,
                    baseUrl + flyer.fthumb,
                    fit: BoxFit.fill,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text(
                              flyer.fname,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 2, 10, 5),
                            child: Text(
                              flyer.description,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                        child: Icon(
                          Icons.picture_as_pdf,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlyerCardgrid(BuildContext context, Flyer flyer) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.4),
                  Theme.of(context).hintColor.withOpacity(0.4),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.8),
                width: 2.5,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: InkWell(
              onTap: () => _openFlyer(flyer.path),
              child: Column(
                children: [
                  Image.network(
                    height: 200,
                    width: double.infinity,
                    baseUrl + flyer.fthumb,
                    fit: BoxFit.fill,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Text(
                                flyer.fname,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).hintColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Text(
                                flyer.description,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).hintColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Icon(
                          Icons.picture_as_pdf,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
