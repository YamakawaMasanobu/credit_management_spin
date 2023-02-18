import java.util.InputMismatchException;
import java.util.Scanner;
public class Credit_condition {
    boolean Nsors;  //New Sales Order Refusal State(新規伝票受付拒否状態)
    boolean Cbf;    //Credit Block Flag(与信ブロックフラグ):trueならON,falseならOFF
    boolean Cs;     //Credit State(与信状態):trueならUNDER,falseならOVER
    double CreditLimit; //与信限度額

    double Receivables; //債権

    public void creditBlockFlagChange(boolean arg, Credit_condition voucher){
        if (arg == true){
            voucher.Cbf = true;
            System.out.println("CreditBlockFlag = " + voucher.Cbf);
        }else if (arg == false){
            voucher.Cbf = false;
            System.out.println("CreditBlockFlag = " + voucher.Cbf);
        }
    }

    public void createSalesOrder(Credit_condition voucher, double newOrderAmount){
        boolean resultNsorsChk = Main.newStateOrderRefusalStateCheck(voucher);

        if(resultNsorsChk == true){
            Main.errorMessageDisplay("You are in New sales order refusal state.");
            System.out.println("receivables = " + voucher.Receivables);
        }else if (resultNsorsChk == false && Main.temporaryCreditCheck(newOrderAmount, voucher) == false){
            voucher.Receivables += newOrderAmount;
            Main.errorMessageDisplay("Over credit limit");
            System.out.println("receivables = " + voucher.Receivables);
            creditBlockFlagChange(true, voucher);
            voucher.Nsors = true;
        }else if (resultNsorsChk == false && Main.temporaryCreditCheck(newOrderAmount, voucher) == true){
            voucher.Receivables += newOrderAmount;
            System.out.println("receivables = " + voucher.Receivables);
            if(Main.creditBlockFlagCheck(voucher) == true){
                creditBlockFlagChange(false, voucher);
            }
        }
    }

    public void raiseCreditLimit (Credit_condition voucher){
        Scanner scan = new Scanner(System.in);
        try {
            System.out.println("Please enter the new maximum amount.");
            double tmp = scan.nextDouble();
            voucher.CreditLimit = tmp;
            System.out.println("New credit limit: " + voucher.CreditLimit);
            if (voucher.Receivables <= voucher.CreditLimit) {
                creditBlockFlagChange(false, voucher);
                voucher.Cs = true;
            }
        }catch (InputMismatchException e){
            Main.errorMessageDisplay("A non-Double type value was entered.");
        }
    }
}
