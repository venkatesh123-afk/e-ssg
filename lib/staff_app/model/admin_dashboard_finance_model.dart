class AdminDashboardFinanceModel {
  String? success;
  Infodata? infodata;

  AdminDashboardFinanceModel({this.success, this.infodata});

  AdminDashboardFinanceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    infodata = json['infodata'] != null ? Infodata.fromJson(json['infodata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (infodata != null) {
      data['infodata'] = infodata!.toJson();
    }
    return data;
  }
}

class Infodata {
  dynamic todayExpenseInfo;
  dynamic monthExpenseInfo;
  dynamic totalExpenseInfo;
  dynamic todayIncomeInfo;
  dynamic monthIncomeInfo;
  dynamic totalIncomeInfo;
  List<FeeCollectionInfo>? todaysFeeCollectionInfo;
  List<FeeCollectionInfo>? yesterdaysFeeCollectionInfo;
  List<FeeCollectionInfo>? thisMonthFeeCollectionInfo;
  List<FeeCollectionInfo>? feeCollectionInfo;
  List<ExpenseTableData>? todaysExpenseTableData;
  List<ExpenseTableData>? yesterdayExpenseTableData;
  List<ExpenseTableData>? thisMonthExpenseTableData;
  List<ExpenseTableData>? totalExpenseTableData;
  List<ExpenseItem>? expensesInfoThisMonth;
  List<ExpenseItem>? expensesInfoToday;
  List<BranchwiseTotalFee>? branchwiseTotalFee;
  TotalSuspended? totalSuspended;
  List<IncomeExpenseInfo>? incomeExpenseInfo;
  List<ExpenseGroup>? expensesGroups;
  List<Cashholding>? cashholdings;

  Infodata({
    this.todayExpenseInfo,
    this.monthExpenseInfo,
    this.totalExpenseInfo,
    this.todayIncomeInfo,
    this.monthIncomeInfo,
    this.totalIncomeInfo,
    this.todaysFeeCollectionInfo,
    this.yesterdaysFeeCollectionInfo,
    this.thisMonthFeeCollectionInfo,
    this.feeCollectionInfo,
    this.todaysExpenseTableData,
    this.yesterdayExpenseTableData,
    this.thisMonthExpenseTableData,
    this.totalExpenseTableData,
    this.expensesInfoThisMonth,
    this.expensesInfoToday,
    this.branchwiseTotalFee,
    this.totalSuspended,
    this.incomeExpenseInfo,
    this.expensesGroups,
    this.cashholdings,
  });

  Infodata.fromJson(Map<String, dynamic> json) {
    todayExpenseInfo = json['today_expense_info'];
    monthExpenseInfo = json['month_expense_info'];
    totalExpenseInfo = json['total_expense_info'];
    todayIncomeInfo = json['today_income_info'];
    monthIncomeInfo = json['month_income_info'];
    totalIncomeInfo = json['total_income_info'];

    if (json['todays_fee_collection_info'] != null) {
      todaysFeeCollectionInfo = <FeeCollectionInfo>[];
      json['todays_fee_collection_info'].forEach((v) => todaysFeeCollectionInfo!.add(FeeCollectionInfo.fromJson(v)));
    }
    if (json['yesterdays_fee_collection_info'] != null) {
      yesterdaysFeeCollectionInfo = <FeeCollectionInfo>[];
      json['yesterdays_fee_collection_info'].forEach((v) => yesterdaysFeeCollectionInfo!.add(FeeCollectionInfo.fromJson(v)));
    }
    if (json['this_month_fee_collection_info'] != null) {
      thisMonthFeeCollectionInfo = <FeeCollectionInfo>[];
      json['this_month_fee_collection_info'].forEach((v) => thisMonthFeeCollectionInfo!.add(FeeCollectionInfo.fromJson(v)));
    }
    if (json['fee_collection_info'] != null) {
      feeCollectionInfo = <FeeCollectionInfo>[];
      json['fee_collection_info'].forEach((v) => feeCollectionInfo!.add(FeeCollectionInfo.fromJson(v)));
    }
    if (json['todays_expense_table_data'] != null) {
      todaysExpenseTableData = <ExpenseTableData>[];
      json['todays_expense_table_data'].forEach((v) => todaysExpenseTableData!.add(ExpenseTableData.fromJson(v)));
    }
    if (json['yesterday_expense_table_data'] != null) {
      yesterdayExpenseTableData = <ExpenseTableData>[];
      json['yesterday_expense_table_data'].forEach((v) => yesterdayExpenseTableData!.add(ExpenseTableData.fromJson(v)));
    }
    if (json['this_month_expense_table_data'] != null) {
      thisMonthExpenseTableData = <ExpenseTableData>[];
      json['this_month_expense_table_data'].forEach((v) => thisMonthExpenseTableData!.add(ExpenseTableData.fromJson(v)));
    }
    if (json['total_expense_table_data'] != null) {
      totalExpenseTableData = <ExpenseTableData>[];
      json['total_expense_table_data'].forEach((v) => totalExpenseTableData!.add(ExpenseTableData.fromJson(v)));
    }
    if (json['expenses_info_this_month'] != null) {
      expensesInfoThisMonth = <ExpenseItem>[];
      json['expenses_info_this_month'].forEach((v) => expensesInfoThisMonth!.add(ExpenseItem.fromJson(v)));
    }
    if (json['expenses_info_today'] != null) {
      expensesInfoToday = <ExpenseItem>[];
      json['expenses_info_today'].forEach((v) => expensesInfoToday!.add(ExpenseItem.fromJson(v)));
    }
    if (json['branchwise_total_fee'] != null) {
      branchwiseTotalFee = <BranchwiseTotalFee>[];
      json['branchwise_total_fee'].forEach((v) => branchwiseTotalFee!.add(BranchwiseTotalFee.fromJson(v)));
    }
    totalSuspended = json['total_suspended'] != null ? TotalSuspended.fromJson(json['total_suspended']) : null;
    if (json['income_expense_info'] != null) {
      incomeExpenseInfo = <IncomeExpenseInfo>[];
      json['income_expense_info'].forEach((v) => incomeExpenseInfo!.add(IncomeExpenseInfo.fromJson(v)));
    }
    if (json['expenses_groups'] != null) {
      expensesGroups = <ExpenseGroup>[];
      json['expenses_groups'].forEach((v) => expensesGroups!.add(ExpenseGroup.fromJson(v)));
    }
    if (json['cashholdings'] != null) {
      cashholdings = <Cashholding>[];
      json['cashholdings'].forEach((v) => cashholdings!.add(Cashholding.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['today_expense_info'] = todayExpenseInfo;
    data['month_expense_info'] = monthExpenseInfo;
    data['total_expense_info'] = totalExpenseInfo;
    data['today_income_info'] = todayIncomeInfo;
    data['month_income_info'] = monthIncomeInfo;
    data['total_income_info'] = totalIncomeInfo;
    if (todaysFeeCollectionInfo != null) data['todays_fee_collection_info'] = todaysFeeCollectionInfo!.map((v) => v.toJson()).toList();
    if (yesterdaysFeeCollectionInfo != null) data['yesterdays_fee_collection_info'] = yesterdaysFeeCollectionInfo!.map((v) => v.toJson()).toList();
    if (thisMonthFeeCollectionInfo != null) data['this_month_fee_collection_info'] = thisMonthFeeCollectionInfo!.map((v) => v.toJson()).toList();
    if (feeCollectionInfo != null) data['fee_collection_info'] = feeCollectionInfo!.map((v) => v.toJson()).toList();
    if (todaysExpenseTableData != null) data['todays_expense_table_data'] = todaysExpenseTableData!.map((v) => v.toJson()).toList();
    if (yesterdayExpenseTableData != null) data['yesterday_expense_table_data'] = yesterdayExpenseTableData!.map((v) => v.toJson()).toList();
    if (thisMonthExpenseTableData != null) data['this_month_expense_table_data'] = thisMonthExpenseTableData!.map((v) => v.toJson()).toList();
    if (totalExpenseTableData != null) data['total_expense_table_data'] = totalExpenseTableData!.map((v) => v.toJson()).toList();
    if (expensesInfoThisMonth != null) data['expenses_info_this_month'] = expensesInfoThisMonth!.map((v) => v.toJson()).toList();
    if (expensesInfoToday != null) data['expenses_info_today'] = expensesInfoToday!.map((v) => v.toJson()).toList();
    if (branchwiseTotalFee != null) data['branchwise_total_fee'] = branchwiseTotalFee!.map((v) => v.toJson()).toList();
    if (totalSuspended != null) data['total_suspended'] = totalSuspended!.toJson();
    if (incomeExpenseInfo != null) data['income_expense_info'] = incomeExpenseInfo!.map((v) => v.toJson()).toList();
    if (expensesGroups != null) data['expenses_groups'] = expensesGroups!.map((v) => v.toJson()).toList();
    if (cashholdings != null) data['cashholdings'] = cashholdings!.map((v) => v.toJson()).toList();
    return data;
  }
}

class FeeCollectionInfo {
  String? branchName;
  dynamic cash;
  dynamic upi;
  dynamic card;
  dynamic netbanking;
  dynamic cheque;
  dynamic total;

  FeeCollectionInfo({this.branchName, this.cash, this.upi, this.card, this.netbanking, this.cheque, this.total});

  FeeCollectionInfo.fromJson(Map<String, dynamic> json) {
    branchName = json['branch_name'];
    cash = json['CASH'];
    upi = json['UPI'];
    card = json['CARD'];
    netbanking = json['NETBANKING'];
    cheque = json['CHEQUE'];
    total = json['Total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_name'] = branchName;
    data['CASH'] = cash;
    data['UPI'] = upi;
    data['CARD'] = card;
    data['NETBANKING'] = netbanking;
    data['CHEQUE'] = cheque;
    data['Total'] = total;
    return data;
  }
}

class ExpenseTableData {
  String? branchName;
  dynamic cash;
  dynamic upi;
  dynamic cheque;
  dynamic total;

  ExpenseTableData({this.branchName, this.cash, this.upi, this.cheque, this.total});

  ExpenseTableData.fromJson(Map<String, dynamic> json) {
    branchName = json['branch_name'];
    cash = json['CASH'];
    upi = json['UPI'];
    cheque = json['CHEQUE'];
    total = json['Total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_name'] = branchName;
    data['CASH'] = cash;
    data['UPI'] = upi;
    data['CHEQUE'] = cheque;
    data['Total'] = total;
    return data;
  }
}

class ExpenseItem {
  String? ledgername;
  dynamic amount;
  String? branchName;

  ExpenseItem({this.ledgername, this.amount, this.branchName});

  ExpenseItem.fromJson(Map<String, dynamic> json) {
    ledgername = json['ledgername'];
    amount = json['amount'];
    branchName = json['branch_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ledgername'] = ledgername;
    data['amount'] = amount;
    data['branch_name'] = branchName;
    return data;
  }
}

class BranchwiseTotalFee {
  int? branchId;
  String? branchName;
  dynamic total;
  dynamic totalPaid;
  dynamic totalDue;
  dynamic totalFee;
  dynamic totalFeePaid;
  dynamic totalFeeDue;
  dynamic totalOther;
  dynamic totalOtherPaid;
  dynamic totalOtherDue;

  BranchwiseTotalFee({
    this.branchId,
    this.branchName,
    this.total,
    this.totalPaid,
    this.totalDue,
    this.totalFee,
    this.totalFeePaid,
    this.totalFeeDue,
    this.totalOther,
    this.totalOtherPaid,
    this.totalOtherDue,
  });

  BranchwiseTotalFee.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    branchName = json['branch_name'];
    total = json['total'];
    totalPaid = json['total_paid'];
    totalDue = json['total_due'];
    totalFee = json['total_fee'];
    totalFeePaid = json['total_fee_paid'];
    totalFeeDue = json['total_fee_due'];
    totalOther = json['total_other'];
    totalOtherPaid = json['total_other_paid'];
    totalOtherDue = json['total_other_due'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    data['branch_name'] = branchName;
    data['total'] = total;
    data['total_paid'] = totalPaid;
    data['total_due'] = totalDue;
    data['total_fee'] = totalFee;
    data['total_fee_paid'] = totalFeePaid;
    data['total_fee_due'] = totalFeeDue;
    data['total_other'] = totalOther;
    data['total_other_paid'] = totalOtherPaid;
    data['total_other_due'] = totalOtherDue;
    return data;
  }
}

class TotalSuspended {
  dynamic total;
  dynamic totalPaid;
  dynamic totalDue;
  dynamic totalFee;
  dynamic totalFeePaid;
  dynamic totalFeeDue;
  dynamic totalOther;
  dynamic totalOtherPaid;
  dynamic totalOtherDue;

  TotalSuspended({
    this.total,
    this.totalPaid,
    this.totalDue,
    this.totalFee,
    this.totalFeePaid,
    this.totalFeeDue,
    this.totalOther,
    this.totalOtherPaid,
    this.totalOtherDue,
  });

  TotalSuspended.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    totalPaid = json['total_paid'];
    totalDue = json['total_due'];
    totalFee = json['total_fee'];
    totalFeePaid = json['total_fee_paid'];
    totalFeeDue = json['total_fee_due'];
    totalOther = json['total_other'];
    totalOtherPaid = json['total_other_paid'];
    totalOtherDue = json['total_other_due'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['total_paid'] = totalPaid;
    data['total_due'] = totalDue;
    data['total_fee'] = totalFee;
    data['total_fee_paid'] = totalFeePaid;
    data['total_fee_due'] = totalFeeDue;
    data['total_other'] = totalOther;
    data['total_other_paid'] = totalOtherPaid;
    data['total_other_due'] = totalOtherDue;
    return data;
  }
}

class IncomeExpenseInfo {
  String? month;
  dynamic income;
  dynamic expense;

  IncomeExpenseInfo({this.month, this.income, this.expense});

  IncomeExpenseInfo.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    income = json['income'];
    expense = json['expense'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['month'] = month;
    data['income'] = income;
    data['expense'] = expense;
    return data;
  }
}

class ExpenseGroup {
  String? ledgername;
  dynamic amount;

  ExpenseGroup({this.ledgername, this.amount});

  ExpenseGroup.fromJson(Map<String, dynamic> json) {
    ledgername = json['ledgername'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ledgername'] = ledgername;
    data['amount'] = amount;
    return data;
  }
}

class Cashholding {
  String? username;
  dynamic credit;
  dynamic debit;
  dynamic netBalance;

  Cashholding({this.username, this.credit, this.debit, this.netBalance});

  Cashholding.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    credit = json['CREDIT'];
    debit = json['DEBIT'];
    netBalance = json['net_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['CREDIT'] = credit;
    data['DEBIT'] = debit;
    data['net_balance'] = netBalance;
    return data;
  }
}
