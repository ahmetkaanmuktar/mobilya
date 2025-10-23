import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/cutting_plan_provider.dart';
import '../services/pdf_service.dart';
import '../utils/app_theme.dart';
import '../widgets/cutting_layout_widget.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isSaving = false;
  
  Future<void> _savePlan() async {
    setState(() => _isSaving = true);
    
    try {
      final provider = Provider.of<CuttingPlanProvider>(context, listen: false);
      await provider.savePlan();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Plan kaydedildi'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }
  
  Future<void> _generateAndSharePdf() async {
    final provider = Provider.of<CuttingPlanProvider>(context, listen: false);
    
    if (provider.currentPlan == null) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('PDF oluşturuluyor...'),
              ],
            ),
          ),
        ),
      ),
    );
    
    try {
      final pdfFile = await PdfService.generatePdf(provider.currentPlan!);
      
      if (mounted) {
        Navigator.pop(context); // Dialog'u kapat
        
        await Share.shareXFiles(
          [XFile(pdfFile.path)],
          text: 'Muktar Marangoz - ${provider.currentPlan!.customerName} Kesim Planı',
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF oluşturulurken hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _shareToWhatsApp() async {
    final provider = Provider.of<CuttingPlanProvider>(context, listen: false);
    
    if (provider.currentPlan == null) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('PDF hazırlanıyor...'),
              ],
            ),
          ),
        ),
      ),
    );
    
    try {
      final pdfFile = await PdfService.generatePdf(provider.currentPlan!);
      
      if (mounted) {
        Navigator.pop(context);
        
        // WhatsApp'a özel paylaşım
        await Share.shareXFiles(
          [XFile(pdfFile.path)],
          text: '''
🪵 *MUKTAR MARANGOZ*
*Müşteri:* ${provider.currentPlan!.customerName}

📋 *Kesim Özeti:*
• Gerekli Tabaka: *${provider.currentPlan!.requiredSheets} Adet*
• Toplam Parça: *${provider.currentPlan!.pieces.fold(0, (sum, p) => sum + p.quantity)} Adet*
• Toplam Alan: *${provider.currentPlan!.totalPiecesArea.toStringAsFixed(2)} m²*
• Artık Alan: *${provider.currentPlan!.wasteArea.toStringAsFixed(2)} m²*
• Artık Oranı: *${provider.currentPlan!.wastePercentage.toStringAsFixed(1)}%*

Detaylı kesim listesi PDF'te mevcuttur.
          ''',
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paylaşım hatası: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesaplama Sonucu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Planı Kaydet',
            onPressed: _isSaving ? null : _savePlan,
          ),
        ],
      ),
      body: Consumer<CuttingPlanProvider>(
        builder: (context, provider, child) {
          if (provider.currentPlan == null) {
            return const Center(child: Text('Plan bulunamadı'));
          }
          
          final plan = provider.currentPlan!;
          
          return SingleChildScrollView(
            child: Column(
              children: [
                // Özet Kartları
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Büyük Sonuç Kartı
                      Card(
                        elevation: 4,
                        color: AppTheme.primaryWood,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.dashboard,
                                size: 48,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Gerekli Tabaka Sayısı',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${plan.requiredSheets} ADET',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${plan.sheetWidth.toInt()} x ${plan.sheetHeight.toInt()} mm',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // İstatistik Kartları
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.inventory_2,
                              title: 'Toplam Parça',
                              value: '${plan.pieces.fold(0, (sum, p) => sum + p.quantity)}',
                              color: AppTheme.secondaryWood,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.square_foot,
                              title: 'Toplam Alan',
                              value: '${plan.totalPiecesArea.toStringAsFixed(2)} m²',
                              color: AppTheme.accentWood,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.recycling,
                              title: 'Artık Alan',
                              value: '${plan.wasteArea.toStringAsFixed(2)} m²',
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.percent,
                              title: 'Artık Oranı',
                              value: '${plan.wastePercentage.toStringAsFixed(1)}%',
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const Divider(),
                
                // Kesim Planı Görselleştirmesi
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kesim Planı',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      CuttingLayoutWidget(plan: plan),
                    ],
                  ),
                ),
                
                const Divider(),
                
                // Detaylı Parça Listesi
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Parça Listesi',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: plan.pieces.length,
                        itemBuilder: (context, index) {
                          final piece = plan.pieces[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: piece.isBanded
                                    ? AppTheme.bandedColor
                                    : AppTheme.unbandedColor,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                '${piece.width.toInt()} x ${piece.height.toInt()} mm',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Adet: ${piece.quantity} | ${piece.isBanded ? "Bantlı ✓" : "Bantsız"} | ${piece.totalArea.toStringAsFixed(3)} m²',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 80), // Alt butonlar için boşluk
              ],
            ),
          );
        },
      ),
      
      // Alt Aksiyon Butonları
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generateAndSharePdf,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('PDF Paylaş'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryWood,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _shareToWhatsApp,
                    icon: const Icon(Icons.share),
                    label: const Text('WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

