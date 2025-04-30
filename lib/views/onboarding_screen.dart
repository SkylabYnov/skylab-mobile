import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:skylab_mobile/widgets/app_logo.dart';
import 'package:skylab_mobile/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _setOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
  }

  Future<bool> _getOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _getOnboardingStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            });
            return Container();
          }

          List<PageViewModel> getPages() {
            return [
              PageViewModel(
                title: "Bienvenue\ndans Skylab",
                body: "Explorez notre application et ses fonctionnalités.",
                image: AppLogo(title: "Skylab"),
                decoration: PageDecoration(
                  imageFlex: 2,
                  bodyFlex: 1,
                  titleTextStyle:
                      Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                  bodyTextStyle:
                      Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                  pageColor: Theme.of(context).scaffoldBackgroundColor,
                  imagePadding: EdgeInsets.all(20),
                ),
              ),
              PageViewModel(
                title: "Fonctionnalités",
                body:
                    "Découvrez toutes les fonctionnalités qui vous attendent.",
                image: AppLogo(title: "Fonctionnalités"),
                // Personnaliser l'image pour cette page
                decoration: PageDecoration(
                  imageFlex: 2,
                  bodyFlex: 1,
                  titleTextStyle:
                      Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                  bodyTextStyle:
                      Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                  pageColor: Theme.of(context).scaffoldBackgroundColor,
                  imagePadding: EdgeInsets.all(20),
                ),
              ),
              PageViewModel(
                title: "Prêt à commencer ?",
                body:
                    "Commencez dès maintenant et profitez de l'expérience Skylab.",
                image: AppLogo(title: "Démarrer"), // Personnaliser l'image
                decoration: PageDecoration(
                  imageFlex: 2,
                  bodyFlex: 1,
                  titleTextStyle:
                      Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                  bodyTextStyle:
                      Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                  pageColor: Theme.of(context).scaffoldBackgroundColor,
                  imagePadding: EdgeInsets.all(20),
                ),
              ),
            ];
          }

          return Scaffold(
            body: SafeArea(
              child: IntroductionScreen(
                pages: getPages(),
                onDone: () {
                  _setOnboardingSeen();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                },
                showNextButton: true,
                next: Icon(Icons.arrow_forward),
                done:
                    Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
                onSkip: () {
                  _setOnboardingSeen();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                },
                showSkipButton: true,
                skip: Text("Skip"),
                dotsDecorator: DotsDecorator(
                  size: Size(10.0, 10.0),
                  activeSize: Size(22.0, 10.0),
                  color: Colors.grey,
                  activeColor: Theme.of(context).primaryColor,
                  spacing: EdgeInsets.symmetric(horizontal: 3.0),
                ),
              ),
            ),
          );
        });
  }
}
