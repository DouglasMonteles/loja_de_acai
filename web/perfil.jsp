<%@page import="java.util.ArrayList"%>
<%@page import="modelo.PerfilDAO"%>
<%@page import="modelo.Perfil"%>
<%
    ArrayList<Perfil> listPerfis = new ArrayList<Perfil>();
    
    try {
        PerfilDAO pDAO = new PerfilDAO();
        listPerfis = pDAO.listar();
    } catch (Exception e) {
        out.print("Erro: " + e);
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
    <head>
        <title>Perfis</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!--Import Google Icon Font-->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link href="node_modules/materialize-css/dist/css/materialize.css" rel="stylesheet" type="text/css"/>
        <link href="css/main.css" rel="stylesheet" type="text/css"/>
        
        <script> 
            function excluir(id, nome) {
                if (window.confirm('Tem certeza que deseja excluir: ' + nome +  '?')) {
                    location.href="gerenciar_perfil.do?tipo=excluir&id=" + id;
                }
            }
        </script>
        
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
                      <h5 style="margin: 0 auto">Perfil 
                          <span class="right right-align">
                              <a class="waves-effect waves-light btn modal-trigger purple" href="inserir_perfil.jsp">
                                  <i class="small material-icons">add</i>
                              </a>
                          </span>
                      </h5>
                    </div>
                <table class="highlight z-depth-5 grey lighten-5 rounded">
                    <thead class="black lighten-3 white-text">
                        <tr>
                          <th>Nome</th>
                          <th>Descri��o</th>
                          <th class="center-align">Op��es</th>
                      </tr>
                    </thead>

                    <tbody>
                      
                        <%
                            for(Perfil itens : listPerfis) {
                        %>
                            <tr>
                                <td><%= itens.getNome() %></td>
                                <td><%= itens.getDescricao() %></td>
                                <td class="center-align">
                                    <a class="modal-trigger waves-effect waves-light btn modal-trigger orange" href="alterar_perfil.jsp?id=<%= itens.getId() %>">
                                        <i class="small material-icons">create</i>
                                    </a>
                                    <a href="#" class="waves-effect waves-light btn modal-trigger red" onclick="excluir(<%= itens.getId() %>, '<%= itens.getNome() %>')">
                                        <i class="small material-icons">delete</i>
                                    </a>
                                    <a href="gerenciar_perfil_menu.jsp?id=<%= itens.getId() %>" class="waves-effect waves-light btn modal-trigger blue">
                                        <i class="small material-icons">settings</i>
                                    </a>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                      
                    </tbody>
                  </table>
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
