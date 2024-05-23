import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/commas.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Provider/product_provider.dart';
import '../../const.dart';
import '../../currency.dart';
import '../../model/product_model.dart';
import 'Constant Data/constant.dart';

class TotalCountWidget extends StatelessWidget {
  const TotalCountWidget({Key? key, required this.icon, required this.title, required this.count, required this.changes, required this.iconColor})
      : super(key: key);

  final String title;
  final String count;
  final IconData icon;
  final int changes;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: kWhiteTextColor,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: kTextStyle.copyWith(color: kGreyTextColor),
          ),
          subtitle: Row(
            children: [
              Text(
                '$currency ${myFormat.format(double.tryParse(count) ?? 0)}',
                maxLines: 2,
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: context.width() < 1000 ? 14 : context.width() * 0.018),
                overflow: TextOverflow.ellipsis,
              ),
              // const SizedBox(width: 10.0),
              // Container(
              //   padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(30.0),
              //     color: changes <0 ? kRedTextColor.withOpacity(0.2) : kGreenTextColor.withOpacity(0.2) ,
              //   ),
              //   child: Text(
              //     '${changes.toString()}%',
              //     style: kTextStyle.copyWith(color: changes <0 ?kRedTextColor : kGreenTextColor, fontSize: 14.0),
              //   ),
              // ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.2),
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomerCountWidget extends StatelessWidget {
  const CustomerCountWidget({super.key, required this.icon, required this.title, required this.count, required this.changes, required this.iconColor});

  final String title;
  final String count;
  final IconData icon;
  final int changes;
  final Color iconColor;


  @override
  Widget build(BuildContext context) {


    return Expanded(
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.25,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: kWhiteTextColor,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: kTextStyle.copyWith(color: kGreyTextColor),
          ),
          subtitle: Row(
            children: [
              Text(
                count,
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: context.width() < 1000 ? 14 : context.width() * 0.018),
              ),
              const SizedBox(width: 10.0),
              Container(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: changes < 0 ? kRedTextColor.withOpacity(0.2) : kGreenTextColor.withOpacity(0.2),
                ),
                child: Text(
                  '${changes.toString()}%',
                  style: kTextStyle.copyWith(color: changes < 0 ? kRedTextColor : kGreenTextColor, fontSize: 14.0),
                ),
              ).visible(false),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.2),
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}

class TotalSummary extends StatelessWidget {
  const TotalSummary({
    super.key,
    required this.title,
    required this.count,
    required this.withOutCurrency,
    required this.footerTitle,
    required this.backgroundColor,
    required this.icon,
    required this.predictIcon,
    required this.predictIconColor,
    required this.monthlyDifferent,
    required this.difWithoutCurrency,
  });

  final String title;
  final String footerTitle;
  final String count;
  final String monthlyDifferent;
  final bool withOutCurrency;
  final bool difWithoutCurrency;
  final Color backgroundColor;
  final String icon;
  final IconData predictIcon;
  final Color predictIconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          // border: Border.all(color: kTitleColor),
          borderRadius: BorderRadius.circular(10.0),
          color: backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                withOutCurrency ? myFormat.format(double.tryParse(count) ?? 0) : '$currency ${myFormat.format(double.tryParse(count) ?? 0)}',
                maxLines: 1,
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: context.width() < 1000 ? 14 : context.width() * 0.018),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: SvgPicture.asset(
                icon,
                height: 50.0,
                width: 42.0,
                allowDrawingOutsideViewBox: false,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.white),
                color: Colors.white.withOpacity(0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    predictIcon,
                    color: predictIconColor,size: 12,
                  ),
                  const SizedBox(width: 4.0),
                  Flexible(
                    child: Text(
                      difWithoutCurrency ? monthlyDifferent : '$currency$monthlyDifferent',
                      style: kTextStyle.copyWith(color: predictIconColor,overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Flexible(
                    child: Text(
                      footerTitle,maxLines: 1,
                      style: kTextStyle.copyWith(color: kGreyTextColor,overflow: TextOverflow.ellipsis),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StatisticsData extends StatefulWidget {
  const StatisticsData(
      {super.key,
      required this.totalSaleCurrentYear,
      required this.totalSaleCurrentMonths,
      required this.totalSaleLastMonth,
      required this.monthlySale,
      required this.dailySale,
      required this.totalSaleCount,
      required this.freeUser, required this.totalExpenseCurrentYear, required this.totalExpenseCurrentMonths, required this.totalExpenseLastMonth, required this.monthlyExpense, required this.dailyExpense});
//_______________Sale_______________
  final double totalSaleCurrentYear;
  final double totalSaleCurrentMonths;
  final double totalSaleLastMonth;
  final List<double> monthlySale;
  final List<int> dailySale;
  final double totalSaleCount;
  final double freeUser;
  //_______________Expense_______________
  final double totalExpenseCurrentYear;
  final double totalExpenseCurrentMonths;
  final double totalExpenseLastMonth;
  final List<double> monthlyExpense;
  final List<int> dailyExpense;


  @override
  State<StatisticsData> createState() => _StatisticsDataState();
}

class _StatisticsDataState extends State<StatisticsData> {
  List<MonthlyIncomeData> data = [
    MonthlyIncomeData('Jan', 0,0),
    MonthlyIncomeData('Feb', 0,0),
    MonthlyIncomeData('Mar', 0,0),
    MonthlyIncomeData('Apr', 0,0),
    MonthlyIncomeData('May', 0,0),
    MonthlyIncomeData('Jun', 0,0),
    MonthlyIncomeData('July', 0,0),
    MonthlyIncomeData('Aug', 0,0),
    MonthlyIncomeData('Sep', 0,0),
    MonthlyIncomeData('Oct', 0,0),
    MonthlyIncomeData('Nov', 0,0),
    MonthlyIncomeData('Dec', 0,0),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = [
      MonthlyIncomeData('Jan', widget.monthlySale[0],widget.monthlyExpense[0]),
      MonthlyIncomeData('Feb', widget.monthlySale[1],widget.monthlyExpense[1]),
      MonthlyIncomeData('Mar', widget.monthlySale[2],widget.monthlyExpense[2]),
      MonthlyIncomeData('Apr', widget.monthlySale[3],widget.monthlyExpense[3]),
      MonthlyIncomeData('May', widget.monthlySale[4],widget.monthlyExpense[4]),
      MonthlyIncomeData('Jun', widget.monthlySale[5],widget.monthlyExpense[5]),
      MonthlyIncomeData('Jul', widget.monthlySale[6],widget.monthlyExpense[6]),
      MonthlyIncomeData('Aug', widget.monthlySale[7],widget.monthlyExpense[7]),
      MonthlyIncomeData('Sep', widget.monthlySale[8],widget.monthlyExpense[8]),
      MonthlyIncomeData('Oct', widget.monthlySale[9],widget.monthlyExpense[9]),
      MonthlyIncomeData('Nov', widget.monthlySale[10],widget.monthlyExpense[10]),
      MonthlyIncomeData('Dec', widget.monthlySale[11],widget.monthlyExpense[11]),
    ];
    dailyData = initializeSalesData();
    getAllTotal();
  }

  List<String> monthList = [
    'This Month',
    'Yearly',
  ];

  String selectedMonth = 'Yearly';

  DropdownButton<String> getCategories() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in monthList) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(
          des,
          style: const TextStyle(color: kTitleColor, fontWeight: FontWeight.normal, fontSize: 14),
        ),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(Icons.keyboard_arrow_down),
      padding: EdgeInsets.zero,
      items: dropDownItems,
      value: selectedMonth,
      onChanged: (value) {
        setState(() {
          selectedMonth = value!;
        });
      },
    );
  }

  final ScrollController stockInventoryScrollController = ScrollController();

  late List<DailyIncomeData> dailyData;

  List<DailyIncomeData> initializeSalesData() {
    return List.generate(
      widget.dailySale.length,
          (index) => DailyIncomeData((index + 1).toString(), widget.dailySale[index].toDouble(),widget.dailyExpense[index].toDouble()),
    );
  }

  int totalStock = 0;
  double totalSalePrice = 0;
  double totalParPrice = 0;








  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double percentageChange = 0.0;
    double freePercentage = ((widget.freeUser * 100) / widget.totalSaleCount);
    double paidPercentage = 100 - freePercentage;
    print(freePercentage);
    print(paidPercentage);
    return Consumer(
      builder: (_, ref, watch) {
        List<ProductModel> stockList =[];
        final product = ref.watch(productProvider);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //________________________________________________Statistics______
            Expanded(
              flex: 4,
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: kBorderColorTextField.withOpacity(0.1), blurRadius: 4, blurStyle: BlurStyle.inner, spreadRadius: 1, offset: const Offset(0, 1))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 57,
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 15.0, 15.0),
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: kBorderColorTextField, width: 2.0),
                      )),
                      child: Row(
                        children: [
                          Icon(MdiIcons.shapeSquareRoundedPlus),
                          const SizedBox(width: 5.0),
                          Text(
                           lang.S.of(context).statistic,
                            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: kTitleColor, fontSize: 16.0),
                          ),
                          const Spacer(),
                          Theme(
                            data: ThemeData(
                                highlightColor: dropdownItemColor,
                                focusColor: dropdownItemColor,
                                hoverColor: dropdownItemColor
                            ),
                            child: DropdownButtonHideUnderline(
                              child: getCategories(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: selectedMonth == 'Yearly',
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: SfCartesianChart(
                          borderWidth: 1.0,
                          backgroundColor: Colors.white,
                          borderColor: Colors.transparent,
                          primaryXAxis: CategoryAxis(
                            majorGridLines: const MajorGridLines(width: 0),
                          ),
                          plotAreaBorderColor: Colors.transparent,
                          legend: const Legend(
                            isVisible: true,
                            alignment: ChartAlignment.center,
                            position: LegendPosition.top,
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries<MonthlyIncomeData, String>>[
                            SplineSeries<MonthlyIncomeData, String>(
                              splineType: SplineType.natural,
                              legendIconType: LegendIconType.circle,
                              dataSource: data,
                              xValueMapper: (MonthlyIncomeData sales, _) => sales.month,
                              yValueMapper: (MonthlyIncomeData sales, _) => sales.sales,
                              name: selectedMonth == 'Yearly'?'Sale($currency${widget.totalSaleCurrentYear.toStringAsFixed(2)})' : 'Sale($currency${widget.totalSaleCurrentMonths.toStringAsFixed(2)})',
                              color: Colors.green,
                              enableTooltip: true,
                              isVisibleInLegend: true,
                              markerSettings: const MarkerSettings(color: Colors.red),
                              isVisible: true,
                              // borderRadius: const BorderRadius.only(
                              //   topRight: Radius.circular(30.0),
                              //   topLeft: Radius.circular(30.0),
                              // ),
                              // Enable data label
                              dataLabelSettings: const DataLabelSettings(isVisible: false),
                            ),
                            SplineSeries<MonthlyIncomeData, String>(
                              splineType: SplineType.natural,
                              legendIconType: LegendIconType.circle,
                              dataSource: data,
                              xValueMapper: (MonthlyIncomeData expense, _) => expense.month,
                              yValueMapper: (MonthlyIncomeData expense, _) => expense.expense,
                              name: selectedMonth == 'Yearly'?'Expense($currency${widget.totalExpenseCurrentYear.toStringAsFixed(2)})' : 'Expense($currency${widget.totalExpenseCurrentMonths.toStringAsFixed(2)})',

                              color: Colors.red,
                              enableTooltip: true,
                              isVisibleInLegend: true,
                              markerSettings: const MarkerSettings(color: Colors.red),
                              isVisible: true,
                              // borderRadius: const BorderRadius.only(
                              //   topRight: Radius.circular(30.0),
                              //   topLeft: Radius.circular(30.0),
                              // ),
                              // Enable data label
                              dataLabelSettings: const DataLabelSettings(isVisible: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: selectedMonth == 'This Month',
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: SfCartesianChart(
                          borderWidth: 1.0,
                          backgroundColor: Colors.white,
                          borderColor: Colors.transparent,
                          primaryXAxis: CategoryAxis(
                            majorGridLines: const MajorGridLines(width: 0),
                          ),
                          plotAreaBorderColor: Colors.transparent,
                          legend: const Legend(
                            isVisible: true,
                            alignment: ChartAlignment.center,
                            position: LegendPosition.top,
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries<DailyIncomeData, String>>[
                            SplineSeries<DailyIncomeData, String>(
                              splineType: SplineType.natural,
                              legendIconType: LegendIconType.circle,
                              dataSource: dailyData,
                              xValueMapper: (DailyIncomeData sales, _) => sales.day,
                              yValueMapper: (DailyIncomeData sales, _) => sales.sales,
                              name: selectedMonth == 'Yearly'? 'Sale($currency${widget.totalSaleCurrentYear.toStringAsFixed(2)})' :  'Sale($currency${widget.totalSaleCurrentMonths.toStringAsFixed(2)})',

                              color: Colors.green,
                              enableTooltip: true,
                              // borderRadius: const BorderRadius.only(
                              //   topRight: Radius.circular(30.0),
                              //   topLeft: Radius.circular(30.0),
                              // ),
                              // Enable data label
                              dataLabelSettings: const DataLabelSettings(isVisible: false),
                            ),
                            SplineSeries<DailyIncomeData, String>(
                              splineType: SplineType.natural,
                              legendIconType: LegendIconType.circle,
                              dataSource: dailyData,
                              xValueMapper: (DailyIncomeData sales, _) => sales.day,
                              yValueMapper: (DailyIncomeData sales, _) => sales.expense,
                              name: selectedMonth == 'Yearly'? 'Expenses($currency${widget.totalExpenseCurrentYear.toStringAsFixed(2)})' :  'Expenses($currency${widget.totalExpenseCurrentMonths.toStringAsFixed(2)})',

                              color: Colors.red,
                              enableTooltip: true,
                              // borderRadius: const BorderRadius.only(
                              //   topRight: Radius.circular(30.0),
                              //   topLeft: Radius.circular(30.0),
                              // ),
                              // Enable data label
                              dataLabelSettings: const DataLabelSettings(isVisible: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              flex: 2,
              child: Container(
                height: 400,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: whiteColor, boxShadow: [
                  BoxShadow(
                      color: kBorderColorTextField.withOpacity(0.7), blurRadius: 4, blurStyle: BlurStyle.inner, spreadRadius: 1, offset: const Offset(0, 1))
                ]),
                child: product.when(
                  data: (productLis) {
                    for (var element in productLis) {
                      if(element.productStock.toInt() < 100){
                        stockList.add(element);
                      }

                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 57,
                          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 15.0, 15.0),
                          decoration: const BoxDecoration(
                              border: Border(
                            bottom: BorderSide(color: kBorderColorTextField, width: 2.0),
                          )),
                          child: Row(
                            children: [
                              Text(
                                lang.S.of(context).stockValues,
                                style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: kMainColor, fontSize: 16.0),
                              ),
                              const Spacer(),
                              Text(
                                '$currency ${myFormat.format(double.tryParse(totalSalePrice.toString()) ?? 0)}',
                                style: textTheme.titleSmall?.copyWith(color: kMainColor, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                          child: Text(
                            lang.S.of(context).lowStock,
                            style: kTextStyle.copyWith(color: kTitleColor, fontSize: 16.0),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 15.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(left: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: kBorderColorTextField),
                              ),
                              child: ScrollbarTheme(
                                data: ScrollbarThemeData(
                                  interactive: true,
                                  radius: const Radius.circular(10.0),
                                  thumbColor: MaterialStateProperty.all(Colors.white),
                                  thickness: MaterialStateProperty.all(8.0),
                                  minThumbLength: 100,
                                  trackColor: MaterialStateProperty.all(kBorderColorTextField),
                                ),
                                child: Scrollbar(
                                  trackVisibility: true,
                                  thickness: 4.0,
                                  interactive: true,
                                  scrollbarOrientation: ScrollbarOrientation.right,
                                  radius: const Radius.circular(20),
                                  controller: stockInventoryScrollController,
                                  thumbVisibility: true,
                                  child:stockList.isNotEmpty?
                                  ListView.builder(
                                    controller: stockInventoryScrollController,
                                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 20.0),
                                    itemCount: stockList.length,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (_, i) {
                                      return Visibility(
                                        visible: stockList[i].productStock.toInt() < 100,
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: const VisualDensity(vertical: -4),
                                          title: Text(
                                            stockList[i].productName,
                                            style: kTextStyle.copyWith(color: kGreyTextColor, overflow: TextOverflow.ellipsis),
                                          ),
                                          trailing: Text(
                                            stockList[i].productStock,
                                            style: kTextStyle.copyWith(color: Colors.red, overflow: TextOverflow.ellipsis,fontSize: 14),
                                          ),
                                        ),
                                      );
                                    },
                                  ):Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child:  Text('Stock is more then low limit',style: kTextStyle.copyWith(color: kGreyTextColor),),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  error: (e, stack) {
                    return Center(
                      child: Text(e.toString()),
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void getAllTotal() async {
    // ignore: unused_local_variable
    List<ProductModel> productList = [];
    await FirebaseDatabase.instance.ref(await getUserID()).child('Products').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        totalStock = totalStock + int.parse(data['productStock']);
        totalSalePrice = totalSalePrice + (int.parse(data['productSalePrice']) * int.parse(data['productStock']));
        totalParPrice = totalParPrice + (int.parse(data['productPurchasePrice']) * int.parse(data['productStock']));
        // productList.add(ProductModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    setState(() {});
  }
}

class MonthlyIncomeData {
  MonthlyIncomeData(this.month, this.sales, this.expense);

  final String month;
  final double sales;
  final double expense;
}

class DailyIncomeData {
  DailyIncomeData(this.day, this.sales, this.expense);

  final String day;
  final double sales;
  final double expense;
}
