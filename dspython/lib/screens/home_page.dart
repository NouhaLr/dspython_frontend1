import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  void loadDashboard() async {
    final data = await ApiService.getDashboard();
    setState(() {
      dashboardData = data;
      isLoading = false;
    });
  }

  void handleLogout() async {
    await ApiService.logout();
    Navigator.pushReplacementNamed(context, '/');
  }

  void goToDeviceSessions() {
    Navigator.pushNamed(context, '/devices');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ).animate().fadeIn(duration: 600.ms).scale(),
          )
              : dashboardData != null
              ? Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bienvenue ! 👋",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(duration: 800.ms).slideX(begin: -1),
                    IconButton(
                      onPressed: handleLogout,
                      icon: Icon(Icons.logout, color: Colors.white),
                      tooltip: 'Se déconnecter',
                    ).animate().fadeIn(duration: 800.ms).slideX(begin: 1),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      ...dashboardData!.entries.map((entry) {
                        return Card(
                          color: Colors.white.withOpacity(0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Icon(Icons.data_usage, color: Colors.blueAccent),
                            title: Text(
                              entry.key,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(entry.value.toString()),
                          ),
                        ).animate().fadeIn(duration: 500.ms).slideY();
                      }),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: goToDeviceSessions,
                        icon: Icon(Icons.devices),
                        label: Text("Voir mes sessions"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ).animate().fadeIn(duration: 700.ms).slideY(),
                    ],
                  ),
                ),
              ],
            ),
          )
              : Center(
            child: Text(
              "Erreur lors de la récupération du tableau de bord.",
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 1),
          ),
        ),
      ),
    );
  }
}
