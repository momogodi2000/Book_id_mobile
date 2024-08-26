import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text('Return Home'),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: AnimationLimiter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // About Section
                    AnimationConfiguration.staggeredList(
                      position: 0,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to the National ID Admin Panel',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                'Our platform is dedicated to streamlining the process of National ID card deliverance. We ensure that the management of users, appointments, and documents is efficient and effective.',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0),

                    // Portfolio Section
                    Text(
                      'Developer Portfolio',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16.0),
                    _buildPortfolioItem(
                      context,
                      'Homepage',
                      'Am momo godi yvan a junior developer from AICS Cameroon...',
                      'assets/images/auth.jpeg',
                      'https://example.com/project1',
                      'https://github.com/momogodi2000/projector-management-app-in-django.git',
                    ),
                    _buildPortfolioItem(
                      context,
                      'Skills',
                      'Programming Languages: Python, JavaScript, PHP, Dart...',
                      'assets/images/auth.jpeg',
                      'https://example.com/project2',
                      'https://github.com/momogodi2000/real-time-collaboration-web-app.git',
                    ),
                    _buildPortfolioItem(
                      context,
                      'Projects',
                      'Ecommerce app in Python...',
                      'assets/images/auth.jpeg',
                      'https://example.com/project3',
                      'https://github.com/momogodi2000/simple-flask-e-commerce-with-sqlite.git',
                    ),
                    const SizedBox(height: 32.0),

                    // Team Section
                    Text(
                      'Meet the Team',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16.0),
                    _buildTeamMember(
                      context,
                      'Momo Yvan',
                      'Project Manager',
                      'assets/images/yvan.jpg',
                    ),
                    const SizedBox(height: 32.0),

                    // Contact Section
                    Text(
                      'Contact Information',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Email: yvangodimomo@gmail.com',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'GitHub: https://github.com/momogodi2000',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'LinkedIn: https://www.linkedin.com/in/momo-godi-yvan-206642244/',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioItem(
      BuildContext context,
      String title,
      String description,
      String imageUrl,
      String demoUrl,
      String codeUrl,
      ) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(imageUrl, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                      onPressed: () => _launchURL(demoUrl),
                      child: const Text('Live Demo'),
                    ),
                    TextButton(
                      onPressed: () => _launchURL(codeUrl),
                      child: const Text('View Code'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(BuildContext context, String name, String role, String imageUrl) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(imageUrl, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Text(
                  role,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
