import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/encryption_service.dart';

class EncryptionScreen extends StatefulWidget {
  const EncryptionScreen({super.key});

  @override
  State<EncryptionScreen> createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {
  final TextEditingController _messageController = TextEditingController();
  String _resultText = '';
  bool _isEncrypted = false;
  String? _errorMessage;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  /// Encrypts the message in the text field
  void _encryptMessage() {
    setState(() {
      _errorMessage = null;
      final message = _messageController.text.trim();

      if (message.isEmpty) {
        _errorMessage = 'Please enter a message to encrypt';
        _resultText = '';
        return;
      }

      try {
        _resultText = EncryptionService.encrypt(message);
        _isEncrypted = true;
      } catch (e) {
        _errorMessage = 'Encryption failed: ${e.toString()}';
        _resultText = '';
        _isEncrypted = false;
      }
    });
  }

  /// Decrypts the message in the text field
  void _decryptMessage() {
    setState(() {
      _errorMessage = null;
      final message = _messageController.text.trim();

      if (message.isEmpty) {
        _errorMessage = 'Please enter an encrypted message to decrypt';
        _resultText = '';
        return;
      }

      try {
        _resultText = EncryptionService.decrypt(message);
        _isEncrypted = false;
      } catch (e) {
        _errorMessage = 'Decryption failed: ${e.toString()}';
        _resultText = '';
        _isEncrypted = false;
      }
    });
  }

  /// Copies the result to clipboard
  void _copyToClipboard() {
    if (_resultText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _resultText));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 2)));
    }
  }

  /// Clears all fields
  void _clearAll() {
    setState(() {
      _messageController.clear();
      _resultText = '';
      _errorMessage = null;
      _isEncrypted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AES-256 Encryption'), backgroundColor: Theme.of(context).colorScheme.inversePrimary, elevation: 2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'Secure Message Encryption',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'AES-256-CBC Encryption',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Input field
              TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message here...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 4,
                minLines: 3,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  // Encrypt buttons
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: _encryptMessage,
                      icon: const Icon(Icons.lock),
                      label: const Text('Encrypt'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Decrypt buttons
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: _decryptMessage,
                      icon: const Icon(Icons.lock_open),
                      label: const Text('Decrypt'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Error message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_errorMessage!, style: TextStyle(color: Colors.red[700])),
                      ),
                    ],
                  ),
                ),
              if (_errorMessage != null) const SizedBox(height: 16),

              // Result section
              if (_resultText.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isEncrypted ? Colors.blue[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _isEncrypted ? Colors.blue[300]! : Colors.green[300]!, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(_isEncrypted ? Icons.lock : Icons.lock_open, color: _isEncrypted ? Colors.blue[700] : Colors.green[700]),
                              const SizedBox(width: 8),
                              Text(
                                _isEncrypted ? 'Encrypted Message' : 'Decrypted Message',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _isEncrypted ? Colors.blue[700] : Colors.green[700]),
                              ),
                            ],
                          ),
                          IconButton(onPressed: _copyToClipboard, icon: const Icon(Icons.copy), tooltip: 'Copy to clipboard'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SelectableText(_resultText, style: const TextStyle(fontSize: 14, fontFamily: 'monospace')),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Clear button
              if (_resultText.isNotEmpty || _messageController.text.isNotEmpty)
                Row(
                  children: [
                    Flexible(
                      child: OutlinedButton.icon(
                        onPressed: _clearAll,
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear All'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
