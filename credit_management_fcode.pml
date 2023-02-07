//1プロセスしか考えていない例，

mtype = {voucher, error_message, msg};
bool Nsors = false, Cbf = false, Cs = true;
short Creditlimit = 1000;
short Receivabole = 0;

chan voucher_ch = [0] of {mtype};
chan money_ch = [0] of {short};
chan tCC_ch = [0] of {bool};
chan nSORSC_ch = [0] of {bool};
chan msg_ch = [0] of {mtype};
chan salesorder_chan = [0] of {mtype};
chan cBFC_chan = [0] of {bool}
chan cBFchk_chan = [0] of {bool}

active proctype temporaryCreditCheck() {
     do
     ::   voucher_ch?voucher ->
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
          break;
     od
}

active proctype newStateOrderRefusalStateCheck(){
     do
     ::   voucher_ch?voucher ->
          do
          ::   nSORSC_ch!true;
               break;
          ::   nSORSC_ch!false;
               break;
          od
     od
}

active proctype creditBlockFlag(){
     do
     ::voucher_ch?voucher ->
          if
          ::   cBFchk_chan!true
          ::   cBFchk_chan!false
          fi;
     od
}

active proctype salesOrder(){
     do
     ::   voucher_ch?voucher ->
          salesorder_chan!voucher;
          break;
     od
}

active proctype creditBlockFlagChange(){
     do
     ::   voucher_ch?voucher ->
          if
          ::   cBFC_chan?true -> Cbf = true;
          ::   cBFC_chan?false -> Cbf = false;
          fi;
     od
}

active proctype createSalesOrder(){
     do
     ::   nSORSC_ch?true ->
          msg_ch!msg;
     ::   nSORSC_ch?false ->
          voucher_ch!voucher
          if
          ::   tCC_ch?false ->
               msg_ch!msg;
               cBFC_chan!true;
               Nsors = true;
          ::   tCC_ch?true ->
               voucher_ch!voucher
               if
               ::   cBFchk_chan?true ->
                    cBFC_chan!false;
               fi;
          fi;
     od
}

// active proctype raiseCreditLimit(){

// }