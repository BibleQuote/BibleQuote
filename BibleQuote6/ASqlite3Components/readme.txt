Author:       Albert Drent
Description:  SQLite DataSet class (encapsulates the Delphi DataSet Class)
Creation:     November 2003
Version:      See source for details.
EMail:        a.drent@aducom.com (www.aducom.com/SQLite)
Support:      support@aducom.com (www.aducom.com/SQLite)
              Please register to the forum on www.aducom.com/sqlite. Here you're questions will be 
              answered. Do not send mail unnoticed to me or support as our filters will intercept 
              and delete. We need to add you to the white list. If needed, we will ask you to send us 
              sources / samples etc. to our supportcenter. 

NOTICE!
To be able to download you must register on our website. This is done to prevent misuse as we have seen in the past. To be able to you must provide a valid email address. Some users are then changing it back to rubbish or use temporary email adresses. We will delete these accounts, if possible even before registration. If you do not want to remain registered then just email support and we will remove you. But have you registered for our newsletter? We only send notices when new editions arrive, so don't be affraid to be spammed for internity. 

Release 2009.02.A
Legal issues: See licence.txt
Important notice: 
We have removed all that is related to static linking. The main reason is that with the utilities of Sasa Zemann (www.szutils.net) it's fairly easy to create the correct obj's and make stuff. This way we don't need to keep up with all the changes of the SQLite3.dll. 

Installation

D4/D5 users:
Within the source of ASGSQLite3.pas there are some switches needed to get the source going for D4 and/of D5. 

// Disable this for ignoring IProvider interface (for D4)
{$DEFINE IPROVIDER}

// Enable this for compilation under D4/D5 
{.$DEFINE D45}


For other users the package should install just fine. This is a VCL package, it does NOT compile with .Net environments. 
             
New installation:

For Delphi 4 and 5 the suffix D4 and D5 are used. Unpack the downloaded zipfile in a subdirectory of your choice. Within Delphi open the required ASQLite package. Choose 'install' to install the components. Don't forget to add the binary folder to the environment search path.

There are two packages, (the second one will by automatically included, so do not install this one!). ASQLite (ASQLiteD4, ASQLiteD5) is the package containing the design-time components. the ASQLitePkg (D4/D5) package contains the runtime package. This is the one to distribute if you are not compiling your projects including the packages. For Borland C++ there are BPK files too. Installation in the similar way.

Upgrade:

Please recompile both packages.

Static linking.

In ASGSqlite set the correct declaration:
// enable this if you want to link the SQLite library statically. (No need for dll)
{.$DEFINE SQLite_Static}

The most actual obj files needed for linking can be downloaded from the download section of www.aducom.com
Change the first obj reference in the source to the correct obj, currently {$L 'OBJ\sqlite3_3_4.obj'}

The website of Aducom SOftware is bilangual. The sqlite components and documentation will be found on the 
English section of the website.


 
			