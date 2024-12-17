import 'package:get/get.dart';
import 'package:amanuel_glass/model/business.dart';
import 'package:amanuel_glass/services/api_services.dart';
import 'package:amanuel_glass/view/components/custom_snackbar.dart';

class PaymentController extends GetxController {
  final Rx<BusinessInfo?> businessInfo = Rx<BusinessInfo?>(null);
  final RxBool isLoading = false.obs;
  final APIServices _apiServices = Get.find<APIServices>();

  Future<void> getBusinessInfo() async {
    try {
      isLoading.value = true;
      final response = await _apiServices.getRequest('business');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        if (jsonData.isNotEmpty) {
          businessInfo.value = BusinessInfo.fromJson(jsonData[0]);
        } else {
          showCustomSnackBar('No business information available');
        }
      } else {
        showCustomSnackBar('Failed to load business information');
      }
    } catch (e) {
      print('Error fetching business info: $e');
      showCustomSnackBar('Error loading business information. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  bool get hasValidBankAccounts {
    return businessInfo.value?.accounts != null && 
           businessInfo.value!.accounts.isNotEmpty;
  }

  List<BankAccount> get bankAccounts {
    return businessInfo.value?.accounts ?? [];
  }

  BankAccount? findBankAccount(String bankName) {
    try {
      return businessInfo.value?.accounts
          .firstWhere((account) => account.bank == bankName);
    } catch (e) {
      return null;
    }
  }

  @override
  void onInit() {
    getBusinessInfo();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh business info if it's not available
    if (!hasValidBankAccounts) {
      getBusinessInfo();
    }
  }
}
