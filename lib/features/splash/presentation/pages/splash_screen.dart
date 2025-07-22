import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/themes/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _logoController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    _logoAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    _fadeController.forward();
    _logoController.forward();

    _fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Future.delayed(const Duration(milliseconds: 500), () async {
          if (mounted) {
            final cacheHelper = CacheHelper();
            final token = await cacheHelper.getData(key: 'token');
            final isComplete = await cacheHelper.getData(
                    key: 'isPharmacyRegistrationComplete') ??
                false;
            print('🧪 Token: $token');
            print('🧪 isPharmacyRegistrationComplete: $isComplete');

            if (token != null && token is String && token.isNotEmpty) {
              if (isComplete) {
                Get.offAllNamed(AppPages.employeeManagement);
              } else {
                Get.offAllNamed(AppPages.pharmacyCompleteRegistration);
              }
            } else {
              Get.offAllNamed(AppPages.signin);
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context)
                          .primaryColor
                          .withOpacity(0.8 * _fadeAnimation.value + 0.2),
                      Colors.white.withOpacity(0.7),
                      Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5 * _fadeAnimation.value + 0.2),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _logoAnimation,
                        builder: (context, child) {
                          return Center(
                            child: Transform.scale(
                              scale: _logoAnimation.value,
                              child: Image.asset(
                                Assets.assetsImagesLogo,
                                scale: 7,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
