import 'package:auctify/screens/category/category.dart';
import 'package:auctify/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryListview extends StatelessWidget {
  CategoryListview({super.key});

  final List<IconData> categoryIcons = [
    Icons.devices,
    Icons.palette,
    Icons.star,
    Icons.directions_car,
    Icons.more_horiz,
  ];

  final List<Color> categoryColor = [
    AppColors.primary,
    AppColors.success,
    Color(0xFFE8618C),
    Color(0xFFEA916E),
    Color(0xFF22CCB2),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(categoriesList.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigate to CategoryScreen with the selected category
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CategoryScreen(category: categoriesList[index]),
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: categoryColor[index],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(categoryIcons[index], color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    categoriesList[index],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
