//1プロセスしか考えていない例，

mtype = {voucher, error_message, msg, finish};
bool Nsors = false, Cbf = false, Cs = true;
int Creditlimit = 1000;
int Receivables = 0;

//各メソッドに引数としてvoucherを渡すためのチャネル
chan vouchertCC_ch = [0] of {int, mtype};  //(amountOfMoney, voucher)
chan vouchernSORSC_ch = [0] of {mtype};
chan vouchercBFchk_ch = [0] of {mtype};
chan vouchersO_ch = [0] of {mtype, int};   //(voucher, orderAmount)
chan vouchercBFC_ch = [0] of {bool, mtype};
chan vouchercSO_ch = [0] of {mtype, int};  //(voucher, newOrderAmount)
chan voucherrCL_ch = [0] of {mtype};

//各メソッドの返り値のためのチャネル
// chan money_ch = [0] of {int};
chan tCC_ch = [0] of {bool};
chan nSORSC_ch = [0] of {bool};
chan msg_ch = [0] of {mtype};
chan cSO_ch = [0] of {mtype};
chan cBFC_ch = [0] of {bool};
chan cBFchk_ch = [0] of {bool};

//createSalesOrderが終わったことを告げるためのチャネル
chan fincSO_ch = [0] of {mtype};
chan finrCL_ch = [0] of {mtype};

chan newMaxAmount_ch = [0] of {int};
chan reset_ch = [0] of {true};

active proctype errorMessageDisplay(){
     do
     ::   msg_ch?msg ->
          msg_ch!error_message;
     od

}

active proctype temporaryCreditCheck() {
     int amountOfMoney
     int tmp
     do
     ::   vouchertCC_ch?amountOfMoney, voucher ->
          tmp = amountOfMoney + Receivables
          if
          ::   tmp <= Creditlimit ->
               tCC_ch!true;
          ::   else ->
               Cs = false;
               tCC_ch!false;
          fi;
     od

}

active proctype newStateOrderRefusalStateCheck(){
     bool resultCbfchk
     do
     ::   vouchernSORSC_ch?voucher ->
          vouchercBFchk_ch!voucher;
          cBFchk_ch?resultCbfchk
          if
          ::   Cs == false && resultCbfchk == true ->
               nSORSC_ch!true;
          ::   else ->
               nSORSC_ch!false;
          fi;
     od
}


active proctype creditBlockFlagCheck(){
     do
     ::vouchercBFchk_ch?voucher ->
          cBFchk_ch!Cbf;
     od
}

active proctype salesOrder(){
     int orderAmount
     do
     ::   vouchersO_ch?voucher, orderAmount->
          vouchercSO_ch!voucher, orderAmount;
     od
}

// active proctype creditBlockFlagChange(){
//      do
//      ::   vouchercBFC_ch?voucher ->
//           if
//           ::   cBFC_ch?true -> Cbf = true;
//           ::   cBFC_ch?false -> Cbf = false;
//           fi;
//      od
// }
active proctype creditBlockFlagChange(){
     do
     ::   vouchercBFC_ch?true, voucher ->
          Cbf = true;
     ::   vouchercBFC_ch?false, voucher ->
          Cbf = false;
     od
}


active proctype createSalesOrder(){
     int newOrderAmount
     do
     ::   vouchercSO_ch?voucher, newOrderAmount;
          vouchernSORSC_ch!voucher;
          // vouchertCC_ch!voucher;
          if
          ::   nSORSC_ch?true ->
               msg_ch!msg;
               msg_ch?error_message;
          ::   nSORSC_ch?false ->
               vouchertCC_ch!newOrderAmount, voucher;
               if
               ::   tCC_ch?false ->
                    Receivables = Receivables + newOrderAmount;
                    msg_ch!msg;
                    msg_ch?error_message;
                    vouchercBFC_ch!true, voucher;
                    Nsors = true;
               ::   tCC_ch?true ->
                    vouchercBFchk_ch!voucher;
                    Receivables = Receivables + newOrderAmount;
                    if
                    ::   cBFchk_ch?true ->
                         vouchercBFC_ch!false, voucher;
                    ::   cBFchk_ch?false ->
                         skip;
                    fi;
               fi;
          fi;
          fincSO_ch!finish;
     od
}

active proctype raiseCreditLimit(){
     int newMaxAmount;
     do
     ::   voucherrCL_ch?voucher;
          newMaxAmount_ch?newMaxAmount;
          Creditlimit = newMaxAmount;
          if
          ::   (Receivables <= Creditlimit) ->
               vouchercBFC_ch!false, voucher;
               Cs = true;
          ::   else ->
               skip;
          fi;
          finrCL_ch!finish;
     od
}

active proctype main(){
     do
     ::   vouchersO_ch!voucher, 500;
          fincSO_ch?finish;
     ::   vouchersO_ch!voucher, 0;
          fincSO_ch?finish;
     ::   vouchersO_ch!voucher, -200;
          fincSO_ch?finish;
     ::   voucherrCL_ch!voucher;
          newMaxAmount_ch!-10000;
          finrCL_ch?finish;
     ::   voucherrCL_ch!voucher;
          newMaxAmount_ch!0;
          finrCL_ch?finish;
     ::   voucherrCL_ch!voucher;
          newMaxAmount_ch!10000;
          finrCL_ch?finish;
     od
     // vouchersO_ch!voucher;
}