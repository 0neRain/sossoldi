import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../custom_widgets/category_type_button.dart';
import '../../../../custom_widgets/default_container.dart';
import '../../../../constants/functions.dart';
import '../../../../constants/style.dart';
import '../../../../model/category_transaction.dart';
import '../../../../providers/categories_provider.dart';
import '../card_label.dart';
import '../linear_progress_bar.dart';
import 'categories_bar_chart.dart';
import 'categories_pie_chart2.dart';
import 'category_label.dart';

class CategoriesCard extends ConsumerStatefulWidget {
  const CategoriesCard({super.key});

  @override
  ConsumerState<CategoriesCard> createState() => _CategoriesCardState();
}

class _CategoriesCardState extends ConsumerState<CategoriesCard> with Functions {
  @override
  Widget build(BuildContext context) {
    final categoryType = ref.watch(categoryTypeProvider);
    final categoryMap = ref.watch(categoryMapProvider(categoryType));

    final categoryTotalAmount = ref.watch(categoryTotalAmountProvider(ref.watch(categoryTypeProvider)));

    return Column(
      children: [
        const CardLabel(label: "Categories"),
        const SizedBox(height: 10),
        DefaultContainer(
            child: categoryMap.when(
          data: (categories) {
            return categoryTotalAmount.value! != 0
                ? Column(
                    children: [
                      const CategoryTypeButton(),
                      const SizedBox(height: 20),
                      CategoriesPieChart2(
                        categoryMap: categories,
                        total: categoryTotalAmount.value ?? 0,
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, i) {
                          if (i == categories.length) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [defaultShadow],
                                ),
                              ),
                            );
                          } else {
                            CategoryTransaction category = categories.keys.elementAt(i);
                            double amount = categories[category] ?? 0;
                            return SizedBox(
                              height: 50.0,
                              child: Column(
                                children: [
                                  const Padding(padding: EdgeInsets.all(2.0)),
                                  CategoryLabel(
                                    category: category,
                                    amount: amount,
                                    total: categoryTotalAmount.value ?? 0,
                                  ),
                                  const SizedBox(height: 4.0),
                                  LinearProgressBar(
                                    type: BarType.category,
                                    amount: amount,
                                    total: categoryTotalAmount.value ?? 0,
                                    colorIndex: category.color,
                                  )
                                ],
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      const CategoriesBarChart()
                    ],
                  )
                : const Column(
                    children: [
                      CategoryTypeButton(),
                      SizedBox(height: 20),
                      NoTransactionsMessage(),
                    ],
                  );
          },
          loading: () => Container(),
          error: (e, s) => Text('Error: $e'),
        ))
      ],
    );
  }
}

class NoTransactionsMessage extends StatelessWidget {
  const NoTransactionsMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Text(
          "After you add some transactions, some outstanding graphs will appear here... almost by magic!",
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
