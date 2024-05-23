import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/commas.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../PDF/print_pdf.dart';
import '../../Provider/profile_provider.dart';
import '../../Provider/sales_returns_provider.dart';
import '../../currency.dart';
import '../../model/sale_transaction_model.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Constant Data/export_button.dart';
import '../Widgets/noDataFound.dart';

class SalesReturnWidget extends StatefulWidget {
  const SalesReturnWidget({Key? key}) : super(key: key);

  @override
  State<SalesReturnWidget> createState() => _SalesReturnWidgetState();
}

class _SalesReturnWidgetState extends State<SalesReturnWidget> {
  double getTotalReturnAmount(List<SaleTransactionModel> transitionModel) {
    double total = 0.0;
    for (var element in transitionModel) {
      total += element.totalAmount! - element.dueAmount!;
    }
    return total;
  }

  double calculateTotalDue(List<dynamic> purchaseTransitionModel) {
    double total = 0.0;
    for (var element in purchaseTransitionModel) {
      total += element.dueAmount!;
    }
    return total;
  }

  ScrollController listScroll = ScrollController();
  String searchItem = '';

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, watch) {
      final transactionReport = ref.watch(saleReturnProvider);
      return transactionReport.when(data: (transaction) {
        List<SaleTransactionModel> reTransaction = [];
        for (var element in transaction.reversed.toList()) {
          if ((element.invoiceNumber.toLowerCase().contains(searchItem.toLowerCase()) || element.customerName.toLowerCase().contains(searchItem.toLowerCase()))) {
            reTransaction.add(element);
          }
        }
        final profile = ref.watch(profileDetailsProvider);
        return Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: kWhiteTextColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color(0xFFCFF4E3),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                myFormat.format(double.tryParse(transaction.length.toString())??0),
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                              ),
                              Text(
                                lang.S.of(context).totalReturns,
                                style: kTextStyle.copyWith(color: kTitleColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        // Container(
                        //   padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10.0),
                        //     color: const Color(0xFFFEE7CB),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         '\$${getTotalDue(transaction).toString()}',
                        //         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                        //       ),
                        //       Text(
                        //         'Unpaid',
                        //         style: kTextStyle.copyWith(color: kTitleColor),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(width: 10.0),
                        Container(
                          padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color(0xFFFED3D3),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$currency${myFormat.format(double.tryParse(getTotalReturnAmount(transaction).toString())??0)}',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                              ),
                              Text(
                                lang.S.of(context).totalReturnAmount,
                                style: kTextStyle.copyWith(color: kTitleColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.all(10.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: kWhiteTextColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          lang.S.of(context).saleReturn,
                          style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),

                        ///___________search________________________________________________-
                        Container(
                          height: 40.0,
                          width: 300,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), border: Border.all(color: kGreyTextColor.withOpacity(0.1))),
                          child: AppTextField(
                            showCursor: true,
                            cursorColor: kTitleColor,
                            onChanged: (value) {
                              setState(() {
                                searchItem = value;
                              });
                            },
                            textFieldType: TextFieldType.NAME,
                            decoration: kInputDecoration.copyWith(
                              contentPadding: const EdgeInsets.all(10.0),
                              hintText: (lang.S.of(context).searchByInvoice),
                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: kGreyTextColor.withOpacity(0.1),
                                  ),
                                  child: const Icon(
                                    FeatherIcons.search,
                                    color: kTitleColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),

                    ///________sate_list_________________________________________________________
                    reTransaction.isNotEmpty
                        ? Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(color: kbgColor),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 35, child: Text('S.L')),
                                    SizedBox(width: 78, child: Text(lang.S.of(context).date)),
                                    SizedBox(width: 50, child: Text(lang.S.of(context).invoice)),
                                    SizedBox(width: 100, child: Text(lang.S.of(context).partyName)),
                                    SizedBox(width: 95, child: Text(lang.S.of(context).partyType)),
                                    SizedBox(width: 70, child: Text(lang.S.of(context).amount)),
                                    SizedBox(width: 60, child: Text(lang.S.of(context).due)),
                                    SizedBox(width: 50, child: Text(lang.S.of(context).status)),
                                    const SizedBox(width: 30, child: Icon(FeatherIcons.settings)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:(MediaQuery.of(context).size.height - 315).isNegative? 0:MediaQuery.of(context).size.height - 315,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: reTransaction.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ///______________S.L__________________________________________________
                                              SizedBox(
                                                width: 40,
                                                child: Text((index + 1).toString(), style: kTextStyle.copyWith(color: kGreyTextColor)),
                                              ),

                                              ///______________Date__________________________________________________
                                              SizedBox(
                                                width: 78,
                                                child: Text(
                                                  reTransaction[index].purchaseDate.substring(0, 10),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2, style: kTextStyle.copyWith(color: kGreyTextColor,overflow: TextOverflow.ellipsis),
                                                ),
                                              ),

                                              ///____________Invoice_________________________________________________
                                              SizedBox(
                                                width: 50,
                                                child: Text(reTransaction[index].invoiceNumber,
                                                    maxLines: 2, overflow: TextOverflow.ellipsis, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                              ),

                                              ///______Party Name___________________________________________________________
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  reTransaction[index].customerName,
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              ///___________Party Type______________________________________________

                                              SizedBox(
                                                width: 95,
                                                child: Text(
                                                  reTransaction[index].paymentType.toString(),
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              ///___________Amount____________________________________________________
                                              SizedBox(
                                                width: 70,
                                                child: Text(
                                                  myFormat.format(double.tryParse( reTransaction[index].totalAmount.toString())??0),
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              ///___________Due____________________________________________________

                                              SizedBox(
                                                width: 60,
                                                child: Text(
                                                  reTransaction[index].dueAmount.toString(),
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              ///___________Due____________________________________________________

                                              SizedBox(
                                                width: 50,
                                                child: Text(
                                                  reTransaction[index].isPaid! ? 'Paid' : "Due",
                                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              ///_______________actions_________________________________________________
                                              SizedBox(
                                                width: 30,
                                                child: Theme(
                                                  data: ThemeData(
                                                      highlightColor: dropdownItemColor,
                                                      focusColor: dropdownItemColor,
                                                      hoverColor: dropdownItemColor
                                                  ),
                                                  child: PopupMenuButton(
                                                    surfaceTintColor: Colors.white,
                                                    padding: EdgeInsets.zero,
                                                    itemBuilder: (BuildContext bc) => [
                                                      PopupMenuItem(
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            await GeneratePdfAndPrint()
                                                                .printSaleInvoice(personalInformationModel: profile.value!, saleTransactionModel: reTransaction[index]);
                                                            // SaleInvoice(
                                                            //   isPosScreen: false,
                                                            //   transitionModel: reTransaction[index],
                                                            //   personalInformationModel: profile.value!,
                                                            // ).launch(context);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Icon(MdiIcons.printer, size: 18.0, color: kTitleColor),
                                                              const SizedBox(width: 4.0),
                                                              Text(
                                                                lang.S.of(context).print,
                                                                style: kTextStyle.copyWith(color: kTitleColor),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    child: Center(
                                                      child: Container(
                                                          height: 18,
                                                          width: 18,
                                                          alignment: Alignment.centerRight,
                                                          child: const Icon(
                                                            Icons.more_vert_sharp,
                                                            size: 18,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 1,
                                          color: kGreyTextColor.withOpacity(0.2),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : EmptyWidget( title: lang.S.of(context).noReportFound)
                  ],
                ),
              )
            ],
          ),
        );
      }, error: (e, stack) {
        return Center(
          child: Text(e.toString()),
        );
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      });
    });
  }
}
