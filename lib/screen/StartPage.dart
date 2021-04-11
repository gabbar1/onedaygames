import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/authentication/SignIn/loginpage.dart';
import 'package:oneday/authentication/Signup/RegisterPage.dart';


class StartPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.cyan,
      body: ListView(
        children: <Widget>[
           Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Image.asset(
                'assets/images/oneday.png',
                width: MediaQuery.of(context).size.width / 1,
                height: 400,
                alignment: Alignment.center,
              ),
              WavyHeader(),
            ],
          ),

          Stack(
            children: [
              Container(
                //child: //WavyFooter(),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 30,right: 30),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Container(

                width: 350,
                padding: EdgeInsets.symmetric(vertical: 13),

                alignment: Alignment.center,
                color: Colors.amber,

                child: Text(
                    'LOGIN',style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline4,)

                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.only(left: 30,right: 30),
            child: InkWell(

              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              child: Container(

                width: 350,
                padding: EdgeInsets.symmetric(vertical: 13),

                alignment: Alignment.center,
                color: Colors.amber,

                child: Text(
                    'REGISTER',style:GoogleFonts.barlowCondensed(textStyle: Theme.of(context).textTheme.headline4,)

                ),
              ),
            ),
          ),


          //new Container(
        ],
      ),
    );
  }
}

const List<Color> orangeGradients = [
  Color(0xFFFF9844),
  Color(0xFFFE8853),
  Color(0xFFFD7267),
];

class WavyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: orangeGradients,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        height: MediaQuery.of(context).size.height / 7.5,
      ),
    );
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();
    path.lineTo(0.0, size.height);

    var firstControlPoint = new Offset(size.width / 7, size.height - 30);
    var firstEndPoint = new Offset(size.width / 6, size.height / 1.5);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    ///move from bottom right to top
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// class StartPage extends StatefulWidget {
//   @override
//   _StartPageState createState() => _StartPageState();
// }

// class _StartPageState extends State<StartPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//           Container(
//         color: Colors.white,
//         margin: EdgeInsets.only(bottom: 10),
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           children: [
//             Spacer(),
//             FlatButton(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5)),
//               color: Colors.orange[300],
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => RegisterPage(),
//                   ),
//                 );
//               },
//               padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
//               child: Text(
//                 'CREATE ACCOUNT',
//               ),
//             ),
//             FlatButton(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5)),
//               color: Colors.orange[300],
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     ///builder: (context) => LoginPage(),
//                     builder: (context) => LoginPage(),
//                   ),
//                 );
//               },
//               padding: EdgeInsets.symmetric(horizontal: 130, vertical: 15),
//               child: Text(
//                 'LOGIN',
//               ),
//             ),
//             SizedBox(
//               height: 40,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }