
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:excel/excel.dart';

import '../model/product_model.dart';

class ExportExcel{

  Future<void> exportXLS(List<ProductModel> products) async{
    var excel = Excel.createExcel();
    final Sheet sheet = excel[excel.getDefaultSheet()!];



    sheet.cell(CellIndex.indexByColumnRow(
      rowIndex: 0,
      columnIndex: 0,
    )).value=TextCellValue('ProductCode');

    sheet.cell(CellIndex.indexByColumnRow(
      rowIndex: 0,
      columnIndex:1 ,
    )).value=TextCellValue('Product Name');

    sheet.cell(CellIndex.indexByColumnRow(
      rowIndex: 0,
      columnIndex:2 ,
    )).value=TextCellValue('Product Stock');

    sheet.cell(CellIndex.indexByColumnRow(
      rowIndex: 0,
      columnIndex:3 ,
    )).value=TextCellValue('Purchase Price');

    sheet.cell(CellIndex.indexByColumnRow(
      rowIndex: 0,
      columnIndex:4,
    )).value=TextCellValue('Wholesale Price');

    sheet.cell(CellIndex.indexByColumnRow(
      rowIndex: 0,
      columnIndex:5,
    )).value=TextCellValue('Sale Price');

    sheet.cell(CellIndex.indexByColumnRow(
      rowIndex: 0,
      columnIndex:6,
    )).value=TextCellValue('Dealer Price');

    sheet.cell(CellIndex.indexByColumnRow(
      rowIndex: 0,
      columnIndex:7,
    )).value=TextCellValue('Category');

    sheet.cell(CellIndex.indexByColumnRow(
      rowIndex: 0,
      columnIndex:8,
    )).value=TextCellValue('Brand');

    sheet.cell(CellIndex.indexByColumnRow(
      rowIndex: 0,
      columnIndex:9,
    )).value=TextCellValue('Units');





    // var row=1;
    for (var row = 0; row < products.length; row++)
      {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row+1))
            .value = TextCellValue(products[row].productCode.toString());

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row+1))
            .value = TextCellValue(products[row].productName.toString());

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row+1))
            .value = TextCellValue(products[row].productStock.toString());

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row+1))
            .value = TextCellValue(products[row].productPurchasePrice.toString());

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row+1))
            .value = TextCellValue(products[row].productSalePrice.toString());


        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row+1))
            .value = TextCellValue(products[row].productWholeSalePrice.toString());

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row+1))
            .value = TextCellValue(products[row].productDealerPrice.toString());


        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row+1))
            .value = TextCellValue(products[row].productCategory.toString());

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row+1))
            .value = TextCellValue(products[row].brandName.toString());

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: row+1))
            .value = TextCellValue(products[row].productUnit.toString());
      }


      // sheet
      //     .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row++))
      //     .value = TextCellValue(element.productCode)

    // for (var row = 0; row < 100; row++) {
    //   sheet
    //       .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
    //       .value = TextCellValue(getRandString());
    //
    //   sheet
    //       .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
    //       .value = TextCellValue(getRandString());
    //
    //   sheet
    //       .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
    //       .value = TextCellValue(getRandString());
    //
    //   sheet
    //       .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
    //       .value = TextCellValue(getRandString());
    //
    //   sheet
    //       .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
    //       .value = TextCellValue(getRandString());
    //
    //   sheet
    //       .cell(CellIndex.indexByColumnRow(columnIndex: 50, rowIndex: row))
    //       .value = TextCellValue(getRandString());
    // }
    sheet.setDefaultColumnWidth();
    sheet.setDefaultRowHeight();

    sheet.setColumnAutoFit(0);
    sheet.setColumnAutoFit(1);
    sheet.setColumnAutoFit(2);

    sheet.setColumnWidth(0, 10.0);
    sheet.setColumnWidth(1, 10.0);
    sheet.setColumnWidth(50, 10.0);

    // sheet.setRowHeight(1, 100);

    // sheet.merge(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
    //     CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 10));

    // final excel = Excel.createExcel();
    //
    // const defaultSheetName = 'Sheet1';
    // const testSheetToKeep = 'Sheet To Keep';
    // const testSheetToKeepRename = 'Rename Of Sheet To Keep';
    //
    // var listDynamic = (List<List<dynamic>>.generate(5, (_) => List<int>.generate(5, (i) => i + 1))
    //   ..insert(0, [
    //     'productCode',
    //     'ProductName',
    //     'Category',
    //     'Brand',
    //     'Stock',
    //     'Purchase price',
    //     'Selling price',
    //     'Dealer price',
    //     'WholeSale price',
    //   ]));
    //
    // for (var row = 0; row < listDynamic.length; row++) {
    //   for (var column = 0; column < listDynamic[row].length; column++) {
    //     final cellIndex = CellIndex.indexByColumnRow(
    //       columnIndex: column,
    //       rowIndex: row,
    //     );
    //
    //     final string = listDynamic[row][column].toString();
    //
    //     var cellValue = int.tryParse(string) != null
    //         ? IntCellValue(int.parse(string))
    //         : TextCellValue(string);
    //
    //     Border border = Border(
    //       borderColorHex: "#FF000000",
    //       borderStyle: BorderStyle.Thin,
    //     );
    //     excel.updateCell(
    //       testSheetToKeep,
    //       cellIndex,
    //       cellValue,
    //       cellStyle: CellStyle(
    //         fontSize:16,
    //         topBorder: border,
    //         bottomBorder: border,
    //         leftBorder: border,
    //         rightBorder: border,
    //         diagonalBorder: border,
    //       )
    //     );
    //   }
    // }
    //
    // ///
    // assert(excel.sheets.keys.contains(defaultSheetName));
    // assert(excel.getDefaultSheet() == defaultSheetName);
    // excel.delete(excel.getDefaultSheet()!);
    // assert(!excel.sheets.keys.contains(defaultSheetName));
    //
    // ///
    // excel.rename(testSheetToKeep, testSheetToKeepRename);
    // excel.setDefaultSheet(testSheetToKeepRename);
    // assert(excel.getDefaultSheet() == testSheetToKeepRename);
    String outputFile = "product.xlsx";

    List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      File(outputFile)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
  }

  String getRandString() {
    final random = Random.secure();
    final len = random.nextInt(20);
    final values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

}