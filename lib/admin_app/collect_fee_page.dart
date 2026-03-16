import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/admin_app/admin_header.dart';

class CollectFeePage extends StatefulWidget {
  final String studentName;
  const CollectFeePage({super.key, required this.studentName});

  @override
  State<CollectFeePage> createState() => _CollectFeePageState();
}

class _CollectFeePageState extends State<CollectFeePage> {
  final TextEditingController _noteController = TextEditingController();
  String _selectedPaymentMode = 'Select Payment Mode';
  String _selectedAccount = 'Select Account';
  final String _date = '12-Mar-2026';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AdminHeader(title: 'Collect Tution Fee'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.studentName} Fee Details',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildFeeHeadCard(
                    sNo: 1,
                    feeHead: 'APPLICATION FEE',
                    committedFee: 500,
                    paidFee: 0,
                    balanceFee: 500,
                  ),
                  const SizedBox(height: 15),
                  _buildFeeHeadCard(
                    sNo: 2,
                    feeHead: 'HOSTEL&TUTION FEE',
                    committedFee: 130000,
                    paidFee: 0,
                    balanceFee: 130000,
                  ),
                  const SizedBox(height: 20),
                  _buildInputDropdown(
                    _date,
                    Icons.calendar_today_outlined,
                    isDate: true,
                  ),
                  const SizedBox(height: 12),
                  _buildInputDropdown(
                    _selectedPaymentMode,
                    Icons.keyboard_arrow_down,
                  ),
                  const SizedBox(height: 12),
                  _buildInputDropdown(
                    _selectedAccount,
                    Icons.keyboard_arrow_down,
                  ),
                  const SizedBox(height: 12),
                  _buildNoteField(),
                  const SizedBox(height: 25),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        Get.snackbar(
                          "Success",
                          "Fee collected successfully",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7E49FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Collect Fee',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeHeadCard({
    required int sNo,
    required String feeHead,
    required double committedFee,
    required double paidFee,
    required double balanceFee,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'S.NO: $sNo',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const Divider(height: 20),
          _buildDetailRow('Fee Head', feeHead),
          _buildDetailRow('Committed Fee', committedFee.toInt().toString()),
          _buildDetailRow('Paid Fee', paidFee.toInt().toString()),
          _buildDetailRow('Balance Fee', balanceFee.toInt().toString()),
          Row(
            children: [
              const Text(
                'Paying Amount : ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildInputDropdown(
    String text,
    IconData icon, {
    bool isDate = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: text.contains('Select') ? Colors.black38 : Colors.black87,
            ),
          ),
          Icon(icon, size: 20, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildNoteField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
      ),
      child: TextField(
        controller: _noteController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Note',
          hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
