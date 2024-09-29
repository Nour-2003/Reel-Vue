
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/Screens/HomePage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class onBoardingScreen extends StatefulWidget {
  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  var boardController = PageController();
  bool islast = false;
  List<onBoardingModel> onBoarding = [
    onBoardingModel(
        image: 'images/Online movie ticket booking.png',
        title: 'Discover New Movies',
        body: 'Stay ahead of the game by tracking upcoming releases and exploring popular and top-rated movies. Whether it\'s a blockbuster or an indie gem, we\'ve got you covered with the latest in cinema!'),
    onBoardingModel(
        image: 'images/Online movie watching.png',
        title: 'Search & Watch Trailers',
        body: 'Find any movie you\'re looking for with our powerful search feature. Watch trailers instantly and decide what\'s worth your time. Your next favorite movie is just a tap away'),
    onBoardingModel(
        image: 'images/Video Editor.png',
        title: 'Build Your Watchlist',
        body: 'Keep track of the movies you want to see by adding them to your personalized watchlist. Never miss a must-watch again—your cinematic experience is just beginning!'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
                child: Text('SKIP',style: GoogleFonts.montserrat(
                    color: Color(0xFFD04848),fontSize: 20,fontWeight: FontWeight.bold
                ),))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                    child: PageView.builder(
                        onPageChanged: (index){
                          if(index == onBoarding.length - 1){
                            setState(() {
                              islast = true;
                            });
                          }else{
                            setState(() {
                              islast = false;
                            });
                          }
                        },
                        controller: boardController,
                        itemBuilder: (context, index) =>
                            OnBoardingItem(onBoarding[index]),
                        itemCount: 3)),
                Row(
                  children: [
                    SmoothPageIndicator(controller: boardController, count: onBoarding.length,
                        effect: ExpandingDotsEffect(
                          dotColor: Colors.grey,
                          activeDotColor:  Color(0xFFD04848),
                          dotHeight: 15,
                          expansionFactor: 3,
                          dotWidth: 15,
                          spacing: 5.0,
                        )
                    ),
                    Spacer(),
                    FloatingActionButton(
                        backgroundColor:  Color(0xFFD04848),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () {
                          if(islast){
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => MyHomePage())
                            );
                          }
                          boardController.nextPage(
                              duration: Duration(microseconds: 750),
                              curve: Curves.fastLinearToSlowEaseIn);
                        },
                        child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,)),
                  ],
                )
              ],
            )));
  }

  Widget OnBoardingItem(onBoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0,horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),  // Adjust the radius as needed
          child: Image(image: AssetImage(model.image)),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(
          '${model.title}',
          style: GoogleFonts.montserrat(
            color: Colors.white,
              fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(height: 15,),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(
          '${model.body}',
          style: GoogleFonts.montserrat(fontSize: 14,
          color: Colors.white),
        ),
      ),
    ],
  );
}

class onBoardingModel {
  final String image;
  final String title;
  final String body;

  onBoardingModel(
      {required this.image, required this.title, required this.body});
}
