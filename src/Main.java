import javax.security.auth.login.CredentialNotFoundException;
import java.util.InputMismatchException;
import java.util.Scanner;
public class Main {

    static void errorMessageDisplay(String message) {
        System.out.println("error: " + message);
    }

    static boolean temporaryCreditCheck(double amountOfMoney, Credit_condition voucher) {
        double tmp = amountOfMoney + voucher.Receivables;
        if (tmp <= voucher.CreditLimit) {
            return true;
        } else {
            voucher.Cs = false;
            return false;
        }
    }

    static boolean newStateOrderRefusalStateCheck(Credit_condition voucher) {
        if (voucher.Cs == false && creditBlockFlagCheck(voucher) == true) {
            return true;
        } else {
            return false;
        }
    }

    static boolean creditBlockFlagCheck(Credit_condition voucher) {
        return voucher.Cbf;
    }

    static void salesOrder(Credit_condition voucher, double orderAmount) {
        voucher.createSalesOrder(voucher, orderAmount);
    }

    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        Credit_condition voucher_sample = new Credit_condition();
        voucher_sample.CreditLimit = 1000;
        voucher_sample.Nsors = false;
        voucher_sample.Cbf = false;
        voucher_sample.Cs = true;
        voucher_sample.Receivables = 0;
        while (true) {
            try{
                System.out.println("Sales order -> 1, Raise Credit Limit -> 2");
                int tmp = scan.nextInt();
                if (tmp == 1) {
                    System.out.println("Please enter sales amount");
                    salesOrder(voucher_sample, scan.nextDouble());
                } else if (tmp == 2) {
                    voucher_sample.raiseCreditLimit(voucher_sample);
                } else{
                    errorMessageDisplay("Please enter 1 or 2.");
                }
            }catch (InputMismatchException e) {
                errorMessageDisplay("A non-Int type value was entered");
            }
        }
    }
}