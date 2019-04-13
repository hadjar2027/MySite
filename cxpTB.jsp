<%@ page import = "java.sql.*,java.util.*,java.text.*,java.lang.*,javax.naming.*,javax.sql.*" %>
<%@ page pageEncoding="ISO-8859-15"%>
<%@ include file= "db2.jsp" %>
<html lang="fr">

  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Impayés CXP</title>
    <!-- Bootstrap -->
    <link href="../vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="../vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <!-- NProgress -->
    <link href="../vendors/nprogress/nprogress.css" rel="stylesheet">
    <!-- iCheck -->
    <link href="../vendors/iCheck/skins/flat/green.css" rel="stylesheet">
    <!-- Datatables -->
    <link href="../vendors/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet">
    <link href="../vendors/datatables.net-buttons-bs/css/buttons.bootstrap.min.css" rel="stylesheet">
    <link href="../vendors/datatables.net-fixedheader-bs/css/fixedHeader.bootstrap.min.css" rel="stylesheet">
    <link href="../vendors/datatables.net-responsive-bs/css/responsive.bootstrap.min.css" rel="stylesheet">
    <link href="../vendors/datatables.net-scroller-bs/css/scroller.bootstrap.min.css" rel="stylesheet">
    <!-- Custom Theme Style -->
    <link href="../build/css/custom.min.css" rel="stylesheet">
  </head>
<body class="nav-mx"> 
<div class="container body">
<div class="main_container">
<% 
//************SECURITY***********//
int wpassage = Integer.parseInt(wagent);
if (wpassage != 001 && wpassage != 100)
{    out.println("<body><img width=15% src=logo.png>");
     out.println("<center>");
     out.println("<br><br><h2><u>Autorisation d'Accès</u></h2>");	
     out.println("<br><br><h2>vous n'êtes pas habilité a utiliser cette fonction !!!</h2><br>");
     out.println("<br><a href='javascript:history.back();' class='btn btn-warning' role='button'> Retour </a>");
     out.println("</center>");
     return;
}
//************SECURITY***********//
//******************** connection SQL SERVER **********************************
//out.println("<b>Bienvenu ["+request.getRemoteUser().trim()+"]</b>");

NumberFormat formatmtP = new DecimalFormat("###,##0.000");
NumberFormat formatmt1 = new DecimalFormat("###,##0");
NumberFormat formatmt  = new DecimalFormat("##0.00");
NumberFormat formatdems = new DecimalFormat("## 0000");
try
{ Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");}
catch (Exception ex){ out.println(ex.toString()); }
Connection conn = null;
try
{ conn = DriverManager.getConnection("jdbc:sqlserver://172.20.100.138:1433;databaseName=cpt_reseaux","sa","azqswx"); }
catch (SQLException ex){ out.println(ex.toString()); }
Statement stmt = conn.createStatement();
ResultSet reslts;
boolean b;
String wsql;
// NB impayEs
wsql="select count(*) AS nb FROM dbo.CxpImp where sit1='E' and sit2='I'";
reslts = stmt.executeQuery(wsql);
b =reslts.next();
String wt=formatmt1.format(reslts.getDouble("nb"));
// NB PAYE
wsql="select count(*) AS nb FROM dbo.CxpImp where sit1='E' and sit2='P' and dmvt like '%2018'";
reslts = stmt.executeQuery(wsql);
b =reslts.next();
String wo=formatmt1.format(reslts.getDouble("nb"));
// NB ANNULE
wsql="select count(*) AS nb FROM dbo.CxpImp where sit1='E' and sit2='A' and dmvt like '%2018'";
reslts = stmt.executeQuery(wsql);
b =reslts.next();
String wa=formatmt1.format(reslts.getDouble("nb"));
// PRIME IMPAYE
wsql="select SUM(ptt-acp1)/1000 AS nb FROM dbo.CxpImp where sit1='E' and sit2='I'";
reslts = stmt.executeQuery(wsql);
b =reslts.next();
String wc=formatmt1.format(reslts.getDouble("nb"));
// DELAIS Traitement
wsql="select sum(DAY(datet-dateo)) as dl,count(*) as nb from clients.dbo.callcenter where DAY(datet-dateo)>0";
reslts = stmt.executeQuery(wsql);
b =reslts.next();
String wdl=formatmt.format(reslts.getDouble("dl")/reslts.getDouble("nb")/2);
// DELAIS cloture
wsql="select sum(DAY(datec-dateo)) as dl,count(*) as nb from clients.dbo.callcenter where DAY(datec-dateo)>0";
reslts = stmt.executeQuery(wsql);
b =reslts.next();
String wdlc=formatmt.format(reslts.getDouble("dl")/reslts.getDouble("nb")*2);

%>

<!-- page content -->
        <div class="right_col" role="main">
        <div> <img width=10% src=logo.png></div>         
		
        <div><center><a href="javascript:history.back();" class="btn btn-warning" role="button"> Retour </a></center></div>		

            <div class="row top_tiles">
              <div class="animated flipInY col-lg-2 col-md-3 col-sm-6 col-xs-12">
                <div class="tile-stats">
                  <div class="icon"><i class="fa fa-caret-square-o-right"></i></div>
                  <div class="count"><%= wt %></div>
                  <h3>Impayés</h3>
                </div>
              </div>
              <div class="animated flipInY col-lg-2 col-md-3 col-sm-6 col-xs-12">
                <div class="tile-stats">
                  <div class="icon"><i class="fa  fa-tachometer"></i></div>
                  <div class="count"><%= wo %></div>
                  <h3>Payés</h3>
                </div>
              </div>
              <div class="animated flipInY col-lg-2 col-md-3 col-sm-6 col-xs-12">
                <div class="tile-stats">
                  <div class="icon"><i class="fa fa-signal"></i></div>
                  <div class="count"><%= wa %></div>
                  <h3>Annulés</h3>
                </div>
              </div>
              <div class="animated flipInY col-lg-2 col-md-3 col-sm-6 col-xs-12">
                <div class="tile-stats">
                  <div class="icon"><i class="fa fa-check-square-o"></i></div>
                  <div class="count"><%= wc %></div>
                  <h3>Prime Impayé</h3>
                </div>
              </div>
			  
              <div class="animated flipInY col-lg-2 col-md-3 col-sm-6 col-xs-12">
                <div class="tile-stats">
                  <div class="icon"><i class="fa fa-sign-out pull-right"></i></div>
                  <div class="count"><%= wdl %> ans</div>
                  <h3>Age Moyen</h3>
                </div>
              </div>			  
			
              <div class="animated flipInY col-lg-2 col-md-3 col-sm-6 col-xs-12">
                <div class="tile-stats">
                  <div class="icon"><i class="fa fa-envelope-o"></i></div>
                  <div class="count"><%= wdlc %> ans</div>
                  <h3>Age Total</h3>
                </div>
              </div>			  
            </div>	
			
		  <div class="">
          <div class="clearfix"></div>
            <div class="row">
              <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
				<div class="x_title">
                    <h1><center>Les Impayés CXP</center></h1>
                    <div class="clearfix"></div>
                  </div>
                  <div class="x_content">
					<table id="datatable-buttons" class="table table-striped table-bordered">
                      <thead>
                        <tr>
 						  <th>Situation</th>
                          <th>Actions</th>
                          <th>Agent</th>
                          <th>Branche</th>						  
                          <th>Police</th>
                          <th>Quittance</th>						  
                          <th>Bordereau</th>						  
                          <th>Mois</th>							  
                          <th>Annee</th>							  						  
                          <th>Assuré(e)</th>	
                          <th>Prime Totale</th>						  
                          <th>Acompte</th>							  
                          <th>Impayé</th>							  
                          <th>Date Emission</th>							  
                          <th>Date CXP</th>						  
                        </tr>
                      </thead>
                      <tbody>			
<% 
wsql="SELECT * FROM cpt_reseaux.dbo.CxpImp where sit1='E' and sit2='I'";
reslts = stmt.executeQuery(wsql);
b =reslts.next();
while(b) 
{
  out.println("<tr>");
  
  String www="";
  if (reslts.getString("SIT2").indexOf("I") >= 0) www="Impayé"; 
  if (reslts.getString("SIT2").indexOf("P") >= 0) www="Payé"; 
  if (reslts.getString("SIT2").indexOf("A") >= 0) www="Annulé"; 
  out.println("<td>"+www+"</td>");

  if (reslts.getString("SIT2").indexOf("I") >= 0)
     {
	  out.println("<td><a href='http://172.20.100.101:90/www/CXP_CXV/encaisse.jsp?quit="+reslts.getString("qit")+"' class='btn btn-warning btn-sm' role='button'>Encaisser</a>");
      out.println("    <a href='http://172.20.100.101:90/www/CXP_CXV/annule.jsp?quit="  +reslts.getString("qit")+"' class='btn btn-primary btn-sm' role='button'>Annuler</a>    </td>");  
	 } 
 
/*	 
  if (reslts.getString("etat").indexOf("P") >= 0) {out.println("<td></td>");}
  if (reslts.getString("etat").indexOf("A") >= 0) {out.println("<td></td>");}
*/

//out.println("<td>"+reslts.getString("agt")+"-"+reslts.getString("agr")+"</td>");
  out.println("<td>"+reslts.getString("agr")+"</td>");
  
  out.println("<td align=right>"+reslts.getString("brc")+"</td>"); 
  out.println("<td align=right>"+reslts.getString("pol")+"</td>");   
  out.println("<td align=right>"+reslts.getString("qit")+"</td>"); 
  
  out.println("<td align=right>"+reslts.getString("fcbr")+"</td>"); 
	
  out.println("<td align=right>"+reslts.getString("mech")+"</td>"); 
  out.println("<td align=right>"+reslts.getString("aech")+"</td>");
  out.println("<td>"+reslts.getString("assure")+"</td>");  
  out.println("<td align=right>"+formatmtP.format(reslts.getDouble("ptt")/1000)+"</td>");   
  out.println("<td align=right>"+formatmtP.format(reslts.getDouble("acp1")/1000)+"</td>");
  out.println("<td align=right>"+formatmtP.format((reslts.getDouble("ptt")/1000)-(reslts.getDouble("acp1")/1000))+"</td>");
  out.println("<td>"+reslts.getString("anem")+"</td>");   
  out.println("<td>"+reslts.getString("dmvt")+"</td>");   
  out.println("</tr>");
  b=reslts.next();
}
if ( reslts != null) { reslts.close();}
if ( stmt   != null) { stmt.close();  }
if ( conn   != null) { conn.close();  }
%>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
    </div>
    </div>
  <div><center><a href="javascript:history.back();" class="btn btn-warning" role="button"> Retour </a></center></div>
    </div>	
	</div>
    </div>
	
     <!-- jQuery -->
    <script src="../vendors/jquery/dist/jquery.min.js"></script>
    <!-- Bootstrap -->
    <script src="../vendors/bootstrap/dist/js/bootstrap.min.js"></script>
    <!-- FastClick -->
    <script src="../vendors/fastclick/lib/fastclick.js"></script>
    <!-- NProgress -->
    <script src="../vendors/nprogress/nprogress.js"></script>
    <!-- iCheck -->
    <script src="../vendors/iCheck/icheck.min.js"></script>
    <!-- Datatables -->
    <script src="../vendors/datatables.net/js/jquery.dataTables.min.js"></script>
    <script src="../vendors/datatables.net-bs/js/dataTables.bootstrap.min.js"></script>
    <script src="../vendors/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
    <script src="../vendors/datatables.net-buttons-bs/js/buttons.bootstrap.min.js"></script>
    <script src="../vendors/datatables.net-buttons/js/buttons.flash.min.js"></script>
    <script src="../vendors/datatables.net-buttons/js/buttons.html5.min.js"></script>
    <script src="../vendors/datatables.net-buttons/js/buttons.print.min.js"></script>
    <script src="../vendors/datatables.net-fixedheader/js/dataTables.fixedHeader.min.js"></script>
    <script src="../vendors/datatables.net-keytable/js/dataTables.keyTable.min.js"></script>
    <script src="../vendors/datatables.net-responsive/js/dataTables.responsive.min.js"></script>
    <script src="../vendors/datatables.net-responsive-bs/js/responsive.bootstrap.js"></script>
    <script src="../vendors/datatables.net-scroller/js/dataTables.scroller.min.js"></script>
    <script src="../vendors/jszip/dist/jszip.min.js"></script>
    <script src="../vendors/pdfmake/build/pdfmake.min.js"></script>
    <script src="../vendors/pdfmake/build/vfs_fonts.js"></script>
    <!-- Custom Theme Scripts -->
    <script src="../build/js/custom.min.js"></script>

  </body>
</html>