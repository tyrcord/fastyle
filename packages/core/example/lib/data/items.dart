import 'package:fastyle_core/fastyle_core.dart';

const fruitsCategory = FastCategory(labelText: 'Fruits', valueText: 'fruits');
const vegetablesCategory = FastCategory(
  labelText: 'Vegetables',
  valueText: 'vegetables',
);

const demoCategories = [fruitsCategory, vegetablesCategory];

final List<FastItem<String>> demoItems = [
  FastItem(
    labelText: 'Apples',
    value: 'apples',
    categories: [fruitsCategory],
  ),
  FastItem(
    labelText: 'Bananas',
    value: 'bananas',
    categories: [fruitsCategory],
  ),
  FastItem(
    labelText: 'Grappes',
    value: 'grappes',
    categories: [fruitsCategory],
  ),
  FastItem(
    labelText: 'Tomatoes',
    value: 'tomatoes',
    categories: [fruitsCategory, vegetablesCategory],
  ),
  FastItem(
    labelText: 'Broccoli',
    value: 'broccoli',
    categories: [vegetablesCategory],
  ),
  FastItem(
    labelText: 'Lettuce',
    value: 'lettuce',
    categories: [vegetablesCategory],
  ),
  FastItem(
    labelText: 'Potato',
    value: 'potato',
    categories: [vegetablesCategory],
  ),
  FastItem(
    labelText: 'Eggplant',
    value: 'eggplant',
    categories: [vegetablesCategory],
  ),
  FastItem(
    labelText: 'Avocado',
    value: 'avocado',
    categories: [vegetablesCategory, fruitsCategory],
  ),
  FastItem(
    labelText: 'Cabbages',
    value: 'cabbages',
    categories: [vegetablesCategory],
  ),
  FastItem(
    labelText: 'Tofu',
    value: 'tofu',
    categories: [vegetablesCategory],
  ),
  FastItem(
    labelText: 'Cucumber',
    value: 'cucumber',
    categories: [vegetablesCategory],
  ),
  FastItem(
    labelText: 'Zucchini',
    value: 'zucchini',
    categories: [vegetablesCategory],
  ),
  FastItem(
    labelText: 'Orange',
    value: 'Orange',
    categories: [fruitsCategory],
  ),
  FastItem(
    labelText: 'Cauliflower',
    value: 'cauliflower',
    categories: [vegetablesCategory],
  ),
  FastItem(
    labelText: 'Spinach',
    value: 'spinach',
    categories: [vegetablesCategory],
  ),
  FastItem(
    labelText: 'Apricots',
    value: 'apricots',
    categories: [fruitsCategory],
  ),
  FastItem(
    labelText: 'Raspberries',
    value: 'raspberries',
    categories: [fruitsCategory],
  ),
  FastItem(
    labelText: 'Kiwifruit',
    value: 'kiwifruit',
    categories: [fruitsCategory],
  ),
  FastItem(
    labelText: 'Pêche',
    value: 'peche',
    categories: [fruitsCategory],
  ),
];
