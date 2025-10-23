import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/cutting_plan.dart';

class PdfService {
  static Future<File> generatePdf(CuttingPlan plan) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              alignment: pw.Alignment.center,
              padding: const pw.EdgeInsets.only(bottom: 20),
              child: pw.Column(
                children: [
                  pw.Text(
                    'MUKTAR MARANGOZ',
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#8B4513'),
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'MDF Kesim Planı',
                    style: pw.TextStyle(
                      fontSize: 16,
                      color: PdfColor.fromHex('#666666'),
                    ),
                  ),
                ],
              ),
            ),
            
            pw.Divider(thickness: 2),
            pw.SizedBox(height: 20),
            
            // Plan Bilgileri
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Müşteri: ${plan.customerName}',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Tarih: ${dateFormat.format(plan.createdAt)}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Tabaka Ölçüsü',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      '${plan.sheetWidth.toInt()} x ${plan.sheetHeight.toInt()} mm',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            
            pw.SizedBox(height: 20),
            
            // Özet Bilgiler
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#F5E6D3'),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    'Gerekli Tabaka',
                    '${plan.requiredSheets} Adet',
                    PdfColor.fromHex('#8B4513'),
                  ),
                  _buildSummaryItem(
                    'Toplam Parça',
                    '${plan.pieces.fold(0, (sum, p) => sum + p.quantity)} Adet',
                    PdfColor.fromHex('#D2691E'),
                  ),
                  _buildSummaryItem(
                    'Artık Alan',
                    '${plan.wasteArea.toStringAsFixed(2)} m²',
                    PdfColor.fromHex('#CD853F'),
                  ),
                ],
              ),
            ),
            
            pw.SizedBox(height: 30),
            
            // Parça Listesi Başlık
            pw.Text(
              'Kesim Listesi',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            
            pw.SizedBox(height: 10),
            
            // Tablo
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(1.5),
                4: const pw.FlexColumnWidth(1.5),
                5: const pw.FlexColumnWidth(2),
              },
              children: [
                // Header
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#8B4513'),
                  ),
                  children: [
                    _buildTableHeader('No'),
                    _buildTableHeader('En (mm)'),
                    _buildTableHeader('Boy (mm)'),
                    _buildTableHeader('Adet'),
                    _buildTableHeader('Bantlı'),
                    _buildTableHeader('Alan (m²)'),
                  ],
                ),
                // Rows
                ...plan.pieces.asMap().entries.map((entry) {
                  final index = entry.key;
                  final piece = entry.value;
                  final isEven = index % 2 == 0;
                  
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: isEven 
                        ? PdfColors.white 
                        : PdfColor.fromHex('#FFF8F0'),
                    ),
                    children: [
                      _buildTableCell('${index + 1}'),
                      _buildTableCell('${piece.width.toInt()}'),
                      _buildTableCell('${piece.height.toInt()}'),
                      _buildTableCell('${piece.quantity}'),
                      _buildTableCell(piece.isBanded ? 'Evet' : 'Hayır'),
                      _buildTableCell(piece.totalArea.toStringAsFixed(3)),
                    ],
                  );
                }),
                // Toplam
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#F5E6D3'),
                  ),
                  children: [
                    _buildTableCell('', bold: true),
                    _buildTableCell('', bold: true),
                    _buildTableCell('', bold: true),
                    _buildTableCell(
                      '${plan.pieces.fold(0, (sum, p) => sum + p.quantity)}',
                      bold: true,
                    ),
                    _buildTableCell('TOPLAM', bold: true),
                    _buildTableCell(
                      plan.totalPiecesArea.toStringAsFixed(3),
                      bold: true,
                    ),
                  ],
                ),
              ],
            ),
            
            if (plan.notes != null && plan.notes!.isNotEmpty) ...[
              pw.SizedBox(height: 20),
              pw.Text(
                'Notlar:',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                plan.notes!,
                style: const pw.TextStyle(fontSize: 11),
              ),
            ],
            
            pw.SizedBox(height: 30),
            
            // Footer
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text(
              'Bu belge Muktar Marangoz uygulaması ile oluşturulmuştur.',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey600,
              ),
            ),
          ];
        },
      ),
    );
    
    // PDF'i kaydet
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/kesim_plan_${plan.id}.pdf');
    await file.writeAsBytes(await pdf.save());
    
    return file;
  }
  
  static pw.Widget _buildSummaryItem(String label, String value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
  
  static pw.Widget _buildTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      ),
    );
  }
  
  static pw.Widget _buildTableCell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}

