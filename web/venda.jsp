<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="modelo.Venda"%>
<%@page import="modelo.VendaDAO"%>
<%@page import="java.util.ArrayList"%>
<%
    DecimalFormat df = new DecimalFormat("#,##0.00");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/y �'s' HH:mm:ss");
    ArrayList<Venda> listVendas = new ArrayList<Venda>();
    VendaDAO vDAO = new VendaDAO();
    
    int limit = 10;
    int offset =  0;
    double qtdVendas = 0;
    String active;
    
    int pag = (request.getParameter("pag") != null) ? Integer.parseInt(request.getParameter("pag")) : 1;
    
    try {
        
        if (pag != 1) {
            offset = (pag * limit) - limit;
        }
        
        listVendas = vDAO.listarPorPaginacao(limit, offset);
        qtdVendas = Math.ceil(vDAO.qtdVendas() / 10.0);
    } catch (Exception e) {
        out.print("Erro: " + e);
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
    <head>
        <title>Vendas</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!--Import Google Icon Font-->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link href="node_modules/materialize-css/dist/css/materialize.css" rel="stylesheet" type="text/css"/>
        <link href="css/main.css" rel="stylesheet" type="text/css"/>
    </head>
    <body class="grey darken-2">
        
        <!--Logo-->
        <%@include file="includes/menu-logo.jsp" %> 
        
        <main>
             <!-- Page Layout here -->
            <div class="row">

              <div class="col s3">
                  <%@include file="includes/menu-lateral.jsp"%>
              </div>

              <div class="col s12 m9">
                <div class="row center-align card-panel grey darken-4 white-text">
                      <h5 style="margin: 0 auto">Vendas</div>
                <table class="highlight z-depth-5 grey lighten-5 rounded">
                    <thead class="black lighten-3 white-text">
                        <tr>
                          <th>ID</th>
                          <th>Data da Venda</th>
                          <th>Data do Pagamento</th>
                          <th>Vendedor</th>
                          <th>Cliente</th>
                          <th class="center-align">Op��es</th>
                      </tr>
                    </thead>

                    <tbody>
                      
                        <%
                            for(Venda v : listVendas) {
                        %>
                            <tr>
                                <td><%= v.getId() %></td>
                                <td><%= sdf.format(v.getDataVenda()) %></td>
                                <td>
                                    <% 
                                        if (v.getDataPagamento() == null) {
                                            out.print("<span class='red-text' style='font-weight: bold'>Pagamento Pendente</span>");
                                        } else {
                                            out.print(sdf.format(v.getDataPagamento()));
                                        }
                                    %>
                                </td>
                                <td><%= v.getVendedor().getNome() %></td>
                                <td><%= v.getCliente().getNome() %></td>
                                <td class="center-align">
                                    <%
                                        if (v.getDataPagamento() == null) {
                                    %>
                                        <a class="modal-trigger waves-effect waves-light btn modal-trigger red" href="registrar_situacao_venda.do?id=<%= v.getId() %>">
                                            Confirmar Pagamento
                                        </a>
                                    <%
                                        }
                                        if (v.getDataPagamento() != null) {
                                    %>
                                    <a class="modal-trigger waves-effect waves-light btn modal-trigger gray" href="recibo.jsp?id=<%= v.getId() %>">
                                        <i class="small material-icons">insert_drive_file</i>
                                    </a>
                                    <%
                                        }
                                    %>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                      
                    </tbody>
                  </table>
                <div class="row center-align">   
                    <ul class="pagination">
                        <%
                            for (int i = 1; i <= qtdVendas; i++) {
                            
                            active = (i == pag) ? "active disabled" : "";
                        %>
                        <li class="waves-effect <%= active %>"><a class="black-text" href="venda.jsp?pag=<%= i %>"><%= i %></a></li>
                        <%
                            }
                        %>
                    </ul>
                </div>
              </div>
            </div>
        </main>
        
        <%@include file="includes/rodape.jsp" %>
        
        
        
        <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
        <script src="node_modules/materialize-css/dist/js/materialize.js" type="text/javascript"></script>
        <script>
                $(".button-collapse").sideNav();
        </script>
    </body>
</html>
