define abstract entity ZCDSMM_A_STATUS_CHANGE_PARAMS
{
    Action: char1; //re[L]ease; re[J]ect; [U]ndo; [F]ile
    Message : char200; //when File, keeps div codes separated by ';'
}
