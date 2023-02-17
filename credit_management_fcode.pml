//1プロセスしか考えていない例，

mtype = {voucher, error_message, msg};
bool Nsors = false, Cbf = false, Cs = true;
short Creditlimit = 1000;
short Receivable = 0;


chan vouchertCC_ch = [0] of {mtype};
chan vouchernSORS_ch = [0] of {mtype};
chan vouchercBFchk_ch = [0] of {mtype};
chan vouchersO_ch = [0] of {mtype};
chan vouchercBFC_ch = [0] of {mtype};

chan money_ch = [0] of {short};
chan tCC_ch = [0] of {bool};
chan nSORSC_ch = [0] of {bool};
chan msg_ch = [0] of {mtype};
chan cSO_chan = [0] of {mtype};
chan cBFC_chan = [0] of {bool}
chan cBFchk_chan = [0] of {bool}

active proctype temporaryCreditCheck() {

     do
     ::   vouchertCC_ch?voucher ->
          do
          ::   tCC_ch!true;
               break;
          ::   Cs = false;
               tCC_ch!false;
               break;
          od
     od

}

active proctype errorMessageDisplay(){
     do
     ::   msg_ch?msg ->
          msg_ch!error_message
     od

}

active proctype newStateOrderRefusalStateCheck(){
     do
     ::   vouchernSORS_ch?voucher ->
          do
          ::   nSORSC_ch!true;
               break;
          ::   nSORSC_ch!false;
               break;
          od
     od
}


active proctype creditBlockFlagCheck(){
     do
     ::vouchercBFchk_ch?voucher ->
          if
          ::   cBFchk_chan!true
          ::   cBFchk_chan!false
          fi;
     od
}

active proctype salesOrder(){
     do
     ::   vouchersO_ch?voucher ->
          cSO_chan!voucher;
     od
}

active proctype creditBlockFlagChange(){
     do
     ::   vouchercBFC_ch?voucher ->
          if
          ::   cBFC_chan?true -> Cbf = true;
          ::   cBFC_chan?false -> Cbf = false;
          fi;
     od
}

active proctype createSalesOrder(){
     do
     ::   cSO_chan?voucher ->
          vouchernSORS_ch!voucher;
          if
          ::   nSORSC_ch?true ->
               msg_ch!msg;
          ::   nSORSC_ch?false ->
               vouchertCC_ch!voucher
               if
               ::   tCC_ch?false ->
                    msg_ch!msg;
                    cBFC_chan!true;
                    Nsors = true;
               ::   tCC_ch?true ->
                    vouchercBFchk_ch!voucher
                    if
                    ::   cBFchk_chan?true ->
                         cBFC_chan!false;
                    fi;
               fi;
          fi;
     od
}

active proctype main(){
     do
     ::   vouchersO_ch!voucher;
          // printf("%c\n", cSO_chan);
     od
     // vouchersO_ch!voucher;
}

// active proctype raiseCreditLimit(){

// }