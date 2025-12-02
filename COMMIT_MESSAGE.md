feat: Add caching for money box and transactions, and support Arabic/English product names in stock management

## Money Box Caching Implementation

### Added Files:
- `lib/features/money_box/data/models/hive_money_box_model.dart` - Hive model for caching money box data
- `lib/features/money_box/data/models/hive_money_box_transaction_model.dart` - Hive model for caching transaction data
- `lib/features/money_box/data/datasources/money_box_local_data_source.dart` - Local data source for money box caching
- `lib/features/money_box/data/datasources/money_box_transaction_local_data_source.dart` - Local data source for transaction caching with pagination support

### Modified Files:
- `lib/features/money_box/data/repositories/get_money_box_repository_impl.dart` - Added caching logic with immediate cache return, background updates, and fallback to cache on errors
- `lib/features/money_box/data/repositories/get_money_box_transaction_repository_impl.dart` - Added caching logic with pagination support, immediate cache return, and fallback to cache
- `lib/features/money_box/presentation/controller/get_money_box_controlller.dart` - Initialized local data source for caching
- `lib/features/money_box/presentation/controller/get_money_box_transaction_controlller.dart` - Initialized local data source for transaction caching
- `lib/main.dart` - Registered Hive adapters and opened Hive boxes for money box and transactions

### Features:
- ✅ Immediate cache return for fast UI response
- ✅ Background cache updates when online
- ✅ Offline support - data available without internet
- ✅ Fallback to cache on network/server errors
- ✅ Pagination support in transaction cache
- ✅ Proper error handling with UnauthorizedException support

## Stock Management - Arabic/English Name Support

### Modified Files:
- `lib/features/stock_management/domain/entities/stock_entity.dart` - Added `productNameAr` and `productNameEn` fields
- `lib/features/stock_management/data/models/stock_model.dart` - Updated to read and store Arabic/English names from JSON
- `lib/features/stock_management/data/models/hive_stock_model.dart` - Updated to use `productNameAr` from data directly
- `lib/features/stock_management/presentation/widgets/product_card.dart` - Added `_getProductName()` method to display name based on locale
- `lib/features/stock_management/presentation/pages/stock_management.dart` - Added `_getProductName()` helper method and updated all product name displays
- `lib/features/stock_management/presentation/widgets/stock_adjustment_sheet.dart` - Added `_getProductName()` method for locale-aware name display

### Features:
- ✅ Display Arabic product names when locale is Arabic
- ✅ Display English product names when locale is English
- ✅ Fallback to `productName` if specific language name not available
- ✅ Consistent name display across all stock management screens
- ✅ Support in ProductCard, StockManagement page, and StockAdjustmentSheet

## Technical Details:

### Money Box Caching:
- Uses Hive typeId 12 for `HiveMoneyBoxModel`
- Uses Hive typeId 13 for `HiveMoneyBoxTransactionModel`
- Cache keys: money box uses ID as key, transactions use ID as key
- Background updates use `Future.microtask` for non-blocking operations
- Proper exception handling with specific catch blocks for UnauthorizedException

### Stock Management:
- Locale-aware name selection using `LocaleController.to.isArabic`
- Maintains backward compatibility with existing `productName` field
- All UI components updated to use the new `_getProductName()` helper methods

## Testing:
- ✅ Money box data cached and retrieved correctly
- ✅ Transaction pagination works with cache
- ✅ Arabic names display correctly when locale is Arabic
- ✅ English names display correctly when locale is English
- ✅ Fallback to default name when language-specific name unavailable
- ✅ No breaking changes to existing functionality

