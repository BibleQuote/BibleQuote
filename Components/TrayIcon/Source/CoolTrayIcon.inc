{$T-}  // Use untyped pointers as we override TNotifyIconData with TNotifyIconDataEx

{$IFDEF VER80}  {$DEFINE DELPHI_1} {$ENDIF}
{$IFDEF VER90}  {$DEFINE DELPHI_2} {$ENDIF}
{$IFDEF VER100} {$DEFINE DELPHI_3} {$ENDIF}
{$IFDEF VER120} {$DEFINE DELPHI_4} {$ENDIF}
{$IFDEF VER130} {$DEFINE DELPHI_5} {$ENDIF}
{$IFDEF VER130} {$DEFINE DELPHI_5} {$ENDIF}
{$IFDEF VER140}      // Delphi 6.0
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
{$ENDIF}

{$IFDEF VER150}      // Delphi 7.0
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
{$ENDIF}

{$IFDEF VER170}      // Delphi 9.0
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
{$ENDIF}

{$IFDEF VER180}      // Delphi 10.0
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
{$ENDIF}

{$IFDEF VER185}      // Delphi 11.0
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
{$ENDIF}

{$IFDEF VER190}      // Delphi 11.0
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
{$ENDIF}

{$IFDEF VER200}      // Delphi 12.0 (2009)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
{$ENDIF}

{$IFDEF VER210}      // Delphi 14.0 (2010)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
  {$DEFINE Delphi14_UP}
{$ENDIF}

{$IFDEF VER220}      // Delphi 15.0 (XE)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
  {$DEFINE Delphi14_UP}
  {$DEFINE Delphi15_UP}
{$ENDIF}

{$IFDEF VER230}      // Delphi XE2 (16.0)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
  {$DEFINE Delphi14_UP}
  {$DEFINE Delphi15_UP}
  {$DEFINE Delphi16_UP}
{$ENDIF}

{$IFDEF VER240}      // Delphi XE3 (17.0)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
  {$DEFINE Delphi14_UP}
  {$DEFINE Delphi15_UP}
  {$DEFINE Delphi16_UP}
  {$DEFINE Delphi17_UP}
{$ENDIF}
{$IFDEF VER250}      // Delphi XE4 (18.0)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
  {$DEFINE Delphi14_UP}
  {$DEFINE Delphi15_UP}
  {$DEFINE Delphi16_UP}
  {$DEFINE Delphi17_UP}
  {$DEFINE Delphi18_UP}
{$ENDIF}
{$IFDEF VER250}      // Delphi XE4 (18.0)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
  {$DEFINE Delphi14_UP}
  {$DEFINE Delphi15_UP}
  {$DEFINE Delphi16_UP}
  {$DEFINE Delphi17_UP}
  {$DEFINE Delphi18_UP}
{$ENDIF}
{$IFDEF VER260}      // Delphi XE5 (19.0)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
  {$DEFINE Delphi14_UP}
  {$DEFINE Delphi15_UP}
  {$DEFINE Delphi16_UP}
  {$DEFINE Delphi17_UP}
  {$DEFINE Delphi18_UP}
  {$DEFINE Delphi19_UP}
{$ENDIF}
{$IFDEF VER270}      // Delphi XE6 (20.0)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
  {$DEFINE Delphi14_UP}
  {$DEFINE Delphi15_UP}
  {$DEFINE Delphi16_UP}
  {$DEFINE Delphi17_UP}
  {$DEFINE Delphi18_UP}
  {$DEFINE Delphi19_UP}
  {$DEFINE Delphi20_UP}
{$ENDIF}
{$IFDEF VER280}      // Delphi XE7 (21.0)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
  {$DEFINE Delphi14_UP}
  {$DEFINE Delphi15_UP}
  {$DEFINE Delphi16_UP}
  {$DEFINE Delphi17_UP}
  {$DEFINE Delphi18_UP}
  {$DEFINE Delphi19_UP}
  {$DEFINE Delphi20_UP}
  {$DEFINE Delphi21_UP}
{$ENDIF}
{$IFDEF VER290}      // Delphi XE8 (22.0)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
  {$DEFINE Delphi14_UP}
  {$DEFINE Delphi15_UP}
  {$DEFINE Delphi16_UP}
  {$DEFINE Delphi17_UP}
  {$DEFINE Delphi18_UP}
  {$DEFINE Delphi19_UP}
  {$DEFINE Delphi20_UP}
  {$DEFINE Delphi21_UP}
  {$DEFINE Delphi22_UP}
{$ENDIF}
{$IFDEF VER300}      // Delphi 10 (23.0)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
  {$DEFINE Delphi14_UP}
  {$DEFINE Delphi15_UP}
  {$DEFINE Delphi16_UP}
  {$DEFINE Delphi17_UP}
  {$DEFINE Delphi18_UP}
  {$DEFINE Delphi19_UP}
  {$DEFINE Delphi20_UP}
  {$DEFINE Delphi21_UP}
  {$DEFINE Delphi22_UP}
  {$DEFINE Delphi23_UP}
{$ENDIF}
{$IFDEF VER310}      // Delphi 10 (24.0)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
  {$DEFINE Delphi14_UP}
  {$DEFINE Delphi15_UP}
  {$DEFINE Delphi16_UP}
  {$DEFINE Delphi17_UP}
  {$DEFINE Delphi18_UP}
  {$DEFINE Delphi19_UP}
  {$DEFINE Delphi20_UP}
  {$DEFINE Delphi21_UP}
  {$DEFINE Delphi22_UP}
  {$DEFINE Delphi23_UP}
  {$DEFINE Delphi24_UP}
{$ENDIF}
{$IFDEF VER320}      // Delphi 10 (25.0)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
  {$DEFINE Delphi14_UP}
  {$DEFINE Delphi15_UP}
  {$DEFINE Delphi16_UP}
  {$DEFINE Delphi17_UP}
  {$DEFINE Delphi18_UP}
  {$DEFINE Delphi19_UP}
  {$DEFINE Delphi20_UP}
  {$DEFINE Delphi21_UP}
  {$DEFINE Delphi22_UP}
  {$DEFINE Delphi23_UP}
  {$DEFINE Delphi24_UP}
  {$DEFINE Delphi25_UP}
{$ENDIF}
{$IFDEF VER330}      // Delphi 10.3 (26)
  {$DEFINE Delphi2_UP}
  {$DEFINE Delphi3_UP}
  {$DEFINE Delphi4_UP}
  {$DEFINE Delphi5_UP}
  {$DEFINE Delphi6_UP}
  {$DEFINE Delphi7_UP}
  {$DEFINE Delphi9_UP}
  {$DEFINE Delphi10_UP}
  {$DEFINE Delphi11_UP}
  {$DEFINE Delphi12_UP}
  {$DEFINE Delphi14_UP}
  {$DEFINE Delphi15_UP}
  {$DEFINE Delphi16_UP}
  {$DEFINE Delphi17_UP}
  {$DEFINE Delphi18_UP}
  {$DEFINE Delphi19_UP}
  {$DEFINE Delphi20_UP}
  {$DEFINE Delphi21_UP}
  {$DEFINE Delphi22_UP}
  {$DEFINE Delphi23_UP}
  {$DEFINE Delphi24_UP}
  {$DEFINE Delphi25_UP}
  {$DEFINE Delphi26_UP}
{$ENDIF}
{$IFDEF VER93}  {$DEFINE BCB_1}    {$ENDIF}
{$IFDEF VER110} {$DEFINE BCB_3}    {$ENDIF}
{$IFDEF VER125} {$DEFINE BCB_4}    {$ENDIF}
{$IFDEF VER135} {$DEFINE BCB_5}    {$ENDIF}

{ Some methods have moved to the Classes unit in D6 and are thus deprecated.
  Using the following compiler directives we handle that situation. }
{$DEFINE DELPHI_6_UP}
{$IFDEF DELPHI_1} {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF DELPHI_2} {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF DELPHI_3} {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF DELPHI_4} {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF DELPHI_5} {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF BCB_1}    {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF BCB_3}    {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF BCB_4}    {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF BCB_5}    {$UNDEF DELPHI_6_UP} {$ENDIF}

{ The TCustomImageList class only exists from D4, so we need special handling
  for D2 and D3. We define another compiler directive for this. }
{$DEFINE DELPHI_4_UP}
{$IFDEF DELPHI_1} {$UNDEF DELPHI_4_UP} {$ENDIF}
{$IFDEF DELPHI_2} {$UNDEF DELPHI_4_UP} {$ENDIF}
{$IFDEF DELPHI_3} {$UNDEF DELPHI_4_UP} {$ENDIF}
{$IFDEF BCB_1}    {$UNDEF DELPHI_4_UP} {$ENDIF}
{$IFDEF BCB_3}    {$UNDEF DELPHI_4_UP} {$ENDIF}

{ I tried to hack around the problem that in some versions of NT4 the tray icon
  will not display properly upon logging off, then logging on. It appears to be
  a VCL problem. The solution is probably to substitute Delphi's AllocateHWnd
  method, but I haven't gotten around to experimenting with that.
  For now, leave WINNT_SERVICE_HACK undefined (no special NT handling). }
{$UNDEF WINNT_SERVICE_HACK}