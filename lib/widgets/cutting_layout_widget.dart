import 'package:flutter/material.dart';
import '../models/cutting_plan.dart';
import '../utils/app_theme.dart';

class CuttingLayoutWidget extends StatelessWidget {
  final CuttingPlan plan;
  
  const CuttingLayoutWidget({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tabaka Dağılımı (Temsili)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            // Her tabaka için bir görselleştirme
            ...List.generate(
              plan.requiredSheets > 3 ? 3 : plan.requiredSheets,
              (sheetIndex) => _buildSheetVisualization(
                context,
                sheetIndex,
                sheetIndex < plan.requiredSheets - 1,
              ),
            ),
            
            if (plan.requiredSheets > 3) ...[
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '... ve ${plan.requiredSheets - 3} tabaka daha',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildSheetVisualization(
    BuildContext context,
    int sheetIndex,
    bool hasMore,
  ) {
    // Tabaka görsel oranı
    final aspectRatio = plan.sheetWidth / plan.sheetHeight;
    
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryWood,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Tabaka ${sheetIndex + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${plan.sheetWidth.toInt()} x ${plan.sheetHeight.toInt()} mm',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        
        AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryWood, width: 2),
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.lightWood.withOpacity(0.3),
            ),
            child: _buildPiecesLayout(sheetIndex),
          ),
        ),
        
        if (hasMore || sheetIndex < 2)
          const SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildPiecesLayout(int sheetIndex) {
    // Basit bir grid layout gösterimi
    // Gerçek kesim optimizasyonu için karmaşık algoritmalar gerekir
    // Burada görsel bir temsil sunuyoruz
    
    final sheetArea = plan.sheetArea;
    int piecesPerSheet = (plan.pieces.fold(0, (sum, p) => sum + p.quantity) / plan.requiredSheets).ceil();
    
    return Padding(
      padding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: 4,
            runSpacing: 4,
            children: List.generate(
              piecesPerSheet > 12 ? 12 : piecesPerSheet,
              (index) {
                if (index < plan.pieces.length) {
                  final piece = plan.pieces[index];
                  final scale = (piece.area / sheetArea) * 800; // Görsel ölçekleme
                  
                  return Container(
                    width: scale.clamp(30, constraints.maxWidth / 3),
                    height: scale.clamp(30, constraints.maxWidth / 3),
                    decoration: BoxDecoration(
                      color: piece.isBanded
                          ? AppTheme.bandedColor.withOpacity(0.7)
                          : AppTheme.unbandedColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        '${piece.width.toInt()}\n×\n${piece.height.toInt()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}

