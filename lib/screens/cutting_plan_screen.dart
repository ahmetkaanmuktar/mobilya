import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../providers/cutting_plan_provider.dart';
import '../utils/app_theme.dart';
import '../models/piece.dart';
import 'result_screen.dart';

class CuttingPlanScreen extends StatefulWidget {
  const CuttingPlanScreen({super.key});

  @override
  State<CuttingPlanScreen> createState() => _CuttingPlanScreenState();
}

class _CuttingPlanScreenState extends State<CuttingPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  
  bool _isBanded = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _listeningField = '';
  
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _loadCustomerName();
  }
  
  void _loadCustomerName() {
    final provider = Provider.of<CuttingPlanProvider>(context, listen: false);
    if (provider.currentPlan != null) {
      _customerNameController.text = provider.currentPlan!.customerName;
    }
  }
  
  @override
  void dispose() {
    _customerNameController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
  
  Future<void> _startListening(String field) async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
    );
    
    if (available) {
      setState(() {
        _isListening = true;
        _listeningField = field;
      });
      
      _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            String text = result.recognizedWords;
            // Sayıları ayıkla
            String numbers = text.replaceAll(RegExp(r'[^0-9]'), '');
            
            setState(() {
              if (field == 'width') {
                _widthController.text = numbers;
              } else if (field == 'height') {
                _heightController.text = numbers;
              } else if (field == 'quantity') {
                _quantityController.text = numbers;
              }
              _isListening = false;
              _listeningField = '';
            });
          }
        },
        localeId: 'tr_TR',
      );
    }
  }
  
  void _addPiece() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<CuttingPlanProvider>(context, listen: false);
      
      provider.addPiece(
        double.parse(_widthController.text),
        double.parse(_heightController.text),
        _isBanded,
        quantity: int.parse(_quantityController.text),
      );
      
      // Formu temizle
      _widthController.clear();
      _heightController.clear();
      _quantityController.text = '1';
      setState(() => _isBanded = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parça eklendi'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
  
  void _showEditDialog(Piece piece) {
    final widthCtrl = TextEditingController(text: piece.width.toString());
    final heightCtrl = TextEditingController(text: piece.height.toString());
    final quantityCtrl = TextEditingController(text: piece.quantity.toString());
    bool banded = piece.isBanded;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Parçayı Düzenle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: widthCtrl,
                  decoration: const InputDecoration(labelText: 'En (cm)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: heightCtrl,
                  decoration: const InputDecoration(labelText: 'Boy (cm)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: quantityCtrl,
                  decoration: const InputDecoration(labelText: 'Adet'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Bantlı'),
                  value: banded,
                  onChanged: (value) => setDialogState(() => banded = value),
                  activeColor: AppTheme.bandedColor,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                final provider = Provider.of<CuttingPlanProvider>(
                  context,
                  listen: false,
                );
                provider.updatePiece(
                  piece.id,
                  width: double.parse(widthCtrl.text),
                  height: double.parse(heightCtrl.text),
                  quantity: int.parse(quantityCtrl.text),
                  isBanded: banded,
                );
                Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kesim Planı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Büyükten Küçüğe Sırala',
            onPressed: () {
              Provider.of<CuttingPlanProvider>(context, listen: false)
                  .sortPiecesBySize();
            },
          ),
        ],
      ),
      body: Consumer<CuttingPlanProvider>(
        builder: (context, provider, child) {
          if (provider.currentPlan == null) {
            return const Center(
              child: Text('Plan yükleniyor...'),
            );
          }
          
          return Column(
            children: [
              // Müşteri Adı ve Tabaka Bilgisi
              Container(
                padding: const EdgeInsets.all(16),
                color: AppTheme.lightWood,
                child: Column(
                  children: [
                    TextField(
                      controller: _customerNameController,
                      decoration: const InputDecoration(
                        labelText: 'Müşteri Adı',
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (value) {
                        provider.updateCustomerName(value);
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.dashboard, color: AppTheme.primaryWood),
                        const SizedBox(width: 8),
                        Text(
                          'Tabaka Ölçüsü: ${(provider.currentPlan!.sheetWidth / 10).toStringAsFixed(1)} x ${(provider.currentPlan!.sheetHeight / 10).toStringAsFixed(1)} cm',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Parça Ekleme Formu
              Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Parça Ekle',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _widthController,
                              decoration: InputDecoration(
                                labelText: 'En (cm)',
                                prefixIcon: const Icon(Icons.straighten),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isListening && _listeningField == 'width'
                                        ? Icons.mic
                                        : Icons.mic_none,
                                    color: _isListening && _listeningField == 'width'
                                        ? Colors.red
                                        : null,
                                  ),
                                  onPressed: () => _startListening('width'),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'En giriniz';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Geçerli bir sayı giriniz';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _heightController,
                              decoration: InputDecoration(
                                labelText: 'Boy (cm)',
                                prefixIcon: const Icon(Icons.height),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isListening && _listeningField == 'height'
                                        ? Icons.mic
                                        : Icons.mic_none,
                                    color: _isListening && _listeningField == 'height'
                                        ? Colors.red
                                        : null,
                                  ),
                                  onPressed: () => _startListening('height'),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Boy giriniz';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Geçerli bir sayı giriniz';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _quantityController,
                              decoration: InputDecoration(
                                labelText: 'Adet',
                                prefixIcon: const Icon(Icons.numbers),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isListening && _listeningField == 'quantity'
                                        ? Icons.mic
                                        : Icons.mic_none,
                                    color: _isListening && _listeningField == 'quantity'
                                        ? Colors.red
                                        : null,
                                  ),
                                  onPressed: () => _startListening('quantity'),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Adet giriniz';
                                }
                                if (int.tryParse(value) == null || int.parse(value) < 1) {
                                  return 'Geçerli bir sayı giriniz';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SwitchListTile(
                              title: const Text('Bantlı'),
                              value: _isBanded,
                              onChanged: (value) {
                                setState(() => _isBanded = value);
                              },
                              activeColor: AppTheme.bandedColor,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _addPiece,
                          icon: const Icon(Icons.add),
                          label: const Text('Parça Ekle'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const Divider(),
              
              // Parça Listesi
              Expanded(
                child: provider.currentPlan!.pieces.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Henüz parça eklenmedi',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.currentPlan!.pieces.length,
                        itemBuilder: (context, index) {
                          final piece = provider.currentPlan!.pieces[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
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
                                '${(piece.width / 10).toStringAsFixed(1)} x ${(piece.height / 10).toStringAsFixed(1)} cm',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                'Adet: ${piece.quantity} | ${piece.isBanded ? "Bantlı" : "Bantsız"} | ${piece.totalArea.toStringAsFixed(3)} m²',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showEditDialog(piece),
                                    color: AppTheme.primaryWood,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      provider.removePiece(piece.id);
                                    },
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              
              // Alt Bar - Hesapla Butonu
              if (provider.currentPlan!.pieces.isNotEmpty)
                Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Toplam Parça',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${provider.currentPlan!.pieces.fold(0, (sum, p) => sum + p.quantity)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryWood,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Toplam Alan',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${provider.currentPlan!.totalPiecesArea.toStringAsFixed(2)} m²',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.secondaryWood,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResultScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calculate),
                          label: const Text(
                            'Hesapla',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

