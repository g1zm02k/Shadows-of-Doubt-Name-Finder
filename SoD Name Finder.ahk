#Requires AutoHotkey 2.0.3+
#SingleInstance Force
SetTitleMatchMode 2
CoordMode "ToolTip"
SetWorkingDir A_ScriptDir

gH:=404,gW:=300
Main:=Gui(,"SoD Name Finder")
Main.SetFont("s11","Consolas")
Main.AddGroupBox("Section x8 y0 w" gW-18 " h" gH-7)
Main.AddText("xs+8 ys+14","Unique Names:")
Main.AddEdit("xs+114 ys+14 w50 h20 Disabled -E0x200",Total(Lists()))
Main.AddText("xs+8 ys+40","Enter found letters...")
Main.SetFont("s15","Consolas")
STR:=Main.AddEdit("xs+8 y+3 w" gW-34 " h30 Center Uppercase Limit19")
STR.OnEvent("Change",Change)
Main.SetFont("s11","Consolas")
CUR:=Main.AddEdit("xs+8 y+3 w" gW-34 " h90 Center ReadOnly r15")
Main.AddText("xs+8 y+3","Found Names:")
CNT:=Main.AddEdit("xs+106 yp w50 h20 Disabled -E0x200",0)
Main.Show("w" gW " h" gH)

Lists(){
  LST:=FileRead("SoD Surnames.txt","UTF-8")
  LST:=StrUpper(LST)
  Return LST
}

Total(TXT){
  TTL:=""
  If TXT
    Loop Parse,TXT,"`n","`r"
      If A_LoopField
        TTL:=A_Index
  Return TTL?TTL:0
}

Change(OBJ,NFO){
  Static LST:=Lists()
  LTR:="",RES:=""
  LTR:=Order(STR.Value)
  If (StrLen(STR.Value)>2)
    Loop Parse,LST,"`n","`r"
    {
      TMP:=RegExReplace(A_LoopField,"i)^.*[^" LTR "].*$")
      If (StrLen(TMP)=StrLen(STR.Value)-1)
        RES.=TMP (TMP?"`n":"")
    }
  TMP:=""
  Loop Parse,RES,"`n","`r"
    If Strip(STR.Value,A_LoopField)
      TMP.=Strip(STR.Value,A_LoopField) "`n"
  CUR.Value:=TMP
  CNT.Value:=Total(CUR.Value)
}

Strip(TXT,ARR){
  Loop Parse,ARR
    TXT:=RegExReplace(TXT,A_LoopField,,,1)
  If (StrLen(TXT)>1) || !StrLen(TXT)
    Return
  Return TXT ". " ARR
}

Order(ARR){
  TMP:=""
  Loop Parse,ARR
    TMP.=A_LoopField "`n"
  TMP:=Sort(TMP,"U")
  Return RegExReplace(TMP,"`n")
}