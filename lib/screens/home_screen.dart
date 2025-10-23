import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cutting_plan_provider.dart';
import '../utils/app_theme.dart';
import 'cutting_plan_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightWood,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo ve Başlık
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryWood.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.carpenter,
                      size: 80,
                      color: AppTheme.primaryWood,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    'MUKTAR MARANGOZ',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppTheme.darkWood,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'MDF Kesim Hesaplama',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.secondaryWood,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Yeni Kesim Planı Butonu
                  _buildMenuButton(
                    context: context,
                    icon: Icons.add_circle_outline,
                    title: 'Yeni Kesim Planı',
                    subtitle: 'Yeni bir hesaplama başlat',
                    color: AppTheme.primaryWood,
                    onTap: () {
                      final provider = Provider.of<CuttingPlanProvider>(
                        context,
                        listen: false,
                      );
                      provider.createNewPlan();
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CuttingPlanScreen(),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Geçmiş Faturalar Butonu
                  _buildMenuButton(
                    context: context,
                    icon: Icons.history,
                    title: 'Geçmiş Faturalar',
                    subtitle: 'Kayıtlı planları görüntüle',
                    color: AppTheme.secondaryWood,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryScreen(),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Bilgi Kartı
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.accentWood,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'MDF plakalarınızın kesim ölçülerini girin, hesaplayın ve WhatsApp ile paylaşın.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMenuButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              
              const SizedBox(width: 20),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

