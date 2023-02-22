//1プロセスしか考えていない例，

mtype = {voucher, error_message, msg, finish};
bool Nsors = false, Cbf = false, Cs = true;
short Creditlimit = 1000;
short Receivable = 0;

//各メソッドに引数としてvoucherを渡すためのチャネル
chan vouchertCC_ch = [0] of {mtype};
chan vouchernSORSC_ch = [0] of {mtype};
chan vouchercBFchk_ch = [0] of {mtype};
chan vouchersO_ch = [0] of {mtype};
chan vouchercBFC_ch = [0] of {mtype, bool};
chan vouchercSO_ch = [0] of {mtype};

//各メソッドの返り値のためのチャネル
// chan money_ch = [0] of {short};
chan tCC_ch = [0] of {bool};
chan nSORSC_ch = [0] of {bool};
chan msg_ch = [0] of {mtype};
chan cSO_chan = [0] of {mtype};
chan cBFC_chan = [0] of {bool};
chan cBFchk_chan = [0] of {bool};

//createSalesOrderが終わったことを告げるためのチャネル
chan fincSO_chan = [0] of {mtype}

active proctype temporaryCreditCheck() {
     do
     ::   vouchertCC_ch?voucher ->
          if
          ::   tCC_ch!true;
          ::   Cs = false;
               tCC_ch!false;
          fi;
     od

}

active proctype errorMessageDisplay(){
     do
     ::   msg_ch?msg ->
          msg_ch!error_message;
     od

}

active proctype newStateOrderRefusalStateCheck(){
     do
     ::   vouchernSORSC_ch?voucher ->
          if
          ::   nSORSC_ch!true;
          ::   nSORSC_ch!false;
          fi;
     od
}


active proctype creditBlockFlagCheck(){
     do
     ::vouchercBFchk_ch?voucher ->
          if
          ::   cBFchk_chan!true;
          ::   cBFchk_chan!false;
          fi;
     od
}

active proctype salesOrder(){
     do
     ::   vouchersO_ch?voucher ->
          vouchercSO_ch!voucher;
     od
}

// active proctype creditBlockFlagChange(){
//      do
//      ::   vouchercBFC_ch?voucher ->
//           if
//           ::   cBFC_chan?true -> Cbf = true;
//           ::   cBFC_chan?false -> Cbf = false;
//           fi;
//      od
// }
active proctype creditBlockFlagChange(){
     do
     ::   vouchercBFC_ch?voucher, true ->
          Cbf = true;
     ::   vouchercBFC_ch?voucher, false ->
          Cbf = false;
     od
}


active proctype createSalesOrder(){
     do
     ::   vouchercSO_ch?voucher ->
          vouchernSORSC_ch!voucher;
          // vouchertCC_ch!voucher;
          if
          ::   nSORSC_ch?true ->
               msg_ch!msg;
               msg_ch?error_message;
          ::   nSORSC_ch?false ->
               vouchertCC_ch!voucher;
               if
               ::   tCC_ch?false ->
                    msg_ch!msg;
                    msg_ch?error_message;
                    vouchercBFC_ch!voucher, true;
                    Nsors = true;
               ::   tCC_ch?true ->
                    vouchercBFchk_ch!voucher;
                    if
                    ::   cBFchk_chan?true ->
                         vouchercBFC_ch!voucher, false;
                    ::   cBFchk_chan?false ->
                         skip;
                    fi;
               fi;
          fi;
          fincSO_chan!finish;
     od
}

active proctype main(){
     do
     ::   vouchersO_ch!voucher;
          fincSO_chan?finish;
          // printf("%c\n", cSO_chan);
     od
     // vouchersO_ch!voucher;
}

// active proctype raiseCreditLimit(){

// }