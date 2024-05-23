// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Invoice/tablet_due_invoice.dart';
import 'package:salespro_admin/responsive.dart' as res;
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/profile_provider.dart';
import '../../currency.dart';
import '../../model/due_transaction_model.dart';
import '../../model/personal_information_model.dart';
import '../Widgets/Constant Data/constant.dart';

class DueInvoice extends StatefulWidget {
  const DueInvoice({Key? key, required this.dueTransactionModel, required this.personalInformationModel}) : super(key: key);
  final DueTransactionModel dueTransactionModel;
  final PersonalInformationModel personalInformationModel;

  @override
  State<DueInvoice> createState() => _DueInvoiceState();
}

class _DueInvoiceState extends State<DueInvoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kRedTextColor),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  FeatherIcons.x,
                  color: kWhiteTextColor,
                  size: 25,
                ),
                const SizedBox(width: 4.0),
                Text(
                  lang.S.of(context).cancel,
                  style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 20.0),
                ),
              ],
            ),
          ).onTap(() => Navigator.pop(context)),
          const SizedBox(width: 20.0),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kRedTextColor),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  MdiIcons.printer,
                  color: kWhiteTextColor,
                  size: 25,
                ),
                const SizedBox(width: 4.0),
                Text(
                  lang.S.of(context).printInvoice,
                  style: kTextStyle.copyWith(color: kWhiteTextColor, fontSize: 20.0),
                ),
              ],
            ),
          ).onTap(() => window.print()),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: res.Responsive(
          mobile: Container(),
          tablet: TabDueInvoice(personalInformationModel: widget.personalInformationModel, dueTransactionModel: widget.dueTransactionModel),
          desktop: Consumer(
            builder: (_, ref, watch) {
              final personalInfo = ref.watch(profileDetailsProvider);
              return personalInfo.when(data: (personalInfo) {
                return SizedBox(
                  width: 700,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.personalInformationModel.companyName.toString(),
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                ),
                                Text(
                                  widget.personalInformationModel.countryName.toString(),
                                  style: kTextStyle.copyWith(color: kTitleColor),
                                ),
                                Text(
                                  widget.personalInformationModel.phoneNumber.toString(),
                                  style: kTextStyle.copyWith(color: kTitleColor),
                                ),
                                Text(
                                  widget.personalInformationModel.countryName.toString(),
                                  style: kTextStyle.copyWith(color: kTitleColor),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(image: NetworkImage(widget.personalInformationModel.pictureUrl.toString()), fit: BoxFit.fill),
                              ),
                            )
                          ],
                        ),
                      ),
                      Center(
                        child: Text(
                          lang.S.of(context).moneyReciept,
                          style: kTextStyle.copyWith(color: kRedTextColor, fontWeight: FontWeight.bold, fontSize: 30.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.S.of(context).billTo,
                              style: kTextStyle.copyWith(color: kTitleColor),
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.dueTransactionModel.customerName,
                                  style: kTextStyle.copyWith(color: kTitleColor),
                                ),
                                const Spacer(),
                                Text(
                                  'Invoice# ${widget.dueTransactionModel.invoiceNumber}',
                                  style: kTextStyle.copyWith(color: kTitleColor),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.dueTransactionModel.customerType.toString(),
                                  style: kTextStyle.copyWith(color: kTitleColor),
                                ),
                                const Spacer(),
                                Text(
                                  'Date:${widget.dueTransactionModel.purchaseDate.substring(0, 10)}',
                                  style: kTextStyle.copyWith(color: kTitleColor),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Phone:${widget.dueTransactionModel.customerPhone}',
                                  style: kTextStyle.copyWith(color: kTitleColor),
                                ),
                                const Spacer(),
                                Text(
                                  'Due Date:${widget.dueTransactionModel.purchaseDate.substring(0, 10)}',
                                  style: kTextStyle.copyWith(color: kTitleColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.all(kRedTextColor),
                                showBottomBorder: false,
                                headingTextStyle: kTextStyle.copyWith(color: kWhiteTextColor, fontWeight: FontWeight.bold),
                                horizontalMargin: null,
                                dividerThickness: 0,
                                headingRowHeight: 30.0,
                                dataRowHeight: 25.0,
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      lang.S.of(context).invoiceNo,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(lang.S.of(context).totalDues),
                                  ),
                                ],
                                rows: List.generate(
                                    1,
                                    (index) => DataRow(
                                          cells: [
                                            DataCell(
                                              Text(widget.dueTransactionModel.invoiceNumber),
                                            ),
                                            DataCell(
                                              Text(widget.dueTransactionModel.totalDue.toString()),
                                            ),
                                          ],
                                        )),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 230,
                                  child: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: const BoxDecoration(color: kRedTextColor),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          lang.S.of(context).totalDue,
                                          maxLines: 1,
                                          style: kTextStyle.copyWith(color: kWhiteTextColor),
                                        ),
                                        const SizedBox(width: 20.0),
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            '$currency ${widget.dueTransactionModel.totalDue}',
                                            maxLines: 2,
                                            style: kTextStyle.copyWith(color: kWhiteTextColor, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  lang.S.of(context).paidAmount,
                                  maxLines: 1,
                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                                const SizedBox(width: 20.0),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    '$currency ${widget.dueTransactionModel.payDueAmount}',
                                    maxLines: 2,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  lang.S.of(context).remainingDue,
                                  maxLines: 1,
                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                                const SizedBox(width: 20.0),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    '$currency ${widget.dueTransactionModel.dueAmountAfterPay}',
                                    maxLines: 2,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  lang.S.of(context).deliveryCharge,
                                  maxLines: 1,
                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                                const SizedBox(width: 20.0),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    '$currency 0.00',
                                    maxLines: 2,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
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
            },
          )),
    );
  }
}
