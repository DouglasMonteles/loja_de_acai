<%@page import="modelo.ItemVendaComanda"%>
<%@page import="modelo.ComandaDAO"%>
<%@page import="modelo.Comanda"%>
<%@page import="modelo.VendaComanda"%>
<%@page import="modelo.TipoProdutoDAO"%>
<%@page import="modelo.TipoProduto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="modelo.ItemVenda"%>
<%@page import="modelo.Cliente"%>
<%@page import="modelo.Venda"%>
<%@page import="modelo.ClienteDAO"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="modelo.ProdutoDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="modelo.Produto"%>

<%
    ArrayList<TipoProduto> listTipo = new ArrayList<TipoProduto>();
    
    try {
        TipoProdutoDAO tpDAO = new TipoProdutoDAO();
        listTipo = tpDAO.listar();
    } catch (Exception e) {
        out.print("Error: " + e);
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
    <head>
        <title>Compra</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!--Import Google Icon Font-->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link href="node_modules/materialize-css/dist/css/materialize.css" rel="stylesheet" type="text/css"/>
        <link href="css/compra.css" rel="stylesheet" type="text/css"/>
      </head>
    <body class="grey darken-2">
        
        <!--Logo-->
        <%@include file="includes/menu-logo.jsp" %> 
        
        <main>
             <!-- Page Layout here -->
            <div class="row">

              <div id="left-menu" class="col s3">
                  <%@include file="includes/menu-lateral.jsp"%>
              </div>
              
              <%
                VendaComanda v = new VendaComanda();
                Comanda c = new Comanda();
                int id_comanda = 0;
                
                if (session.getAttribute("id_comanda") != null) {
                    id_comanda = (Integer) session.getAttribute("id_comanda");
                }
                
                int id = Integer.parseInt(request.getParameter("id"));

                try {
                    String op = request.getParameter("op");

                    if ("n".equals(op)) {
                        ComandaDAO cDAO = new ComandaDAO();
                        c = cDAO.carregarPorId(id);

                        v.setComanda(c);
                        v.setVendedor(session_user);
                        v.setCarrinho(new ArrayList<ItemVendaComanda>());
                        
                        session.setAttribute("venda_comanda", v);
                    } else {
                        v = (VendaComanda) session.getAttribute("venda_comanda");
                    }
                } catch (Exception e) {
                    out.print("Erro: " + e);
                }
            %>

              <div class="col s12 m12 l12">
                  <div class="row center-align card-panel grey darken-4 white-text"> 
                      <h5 style="margin: 0 auto">Catálogo de Produtos 
                        <span class="right right-align">
                                <a class="waves-effect waves-light btn modal-trigger purple" href="#" onclick="verificaCarrinho(<%= id_comanda %>, <%= id %>)">
                                <i class="small material-icons">add_shopping_cart</i>
                            </a>
                        </span>
                    </h5>
                </div>
                  
                  <div class="container">
                      <div class="row white black-text center-block" style="border-radius: 20px">
                          
                          <div class="input-field col s8">
                              <input type="text" value="" id="autocomplete-input" class="autocomplete">
                                  <label for="autocomplete-input">Nome do produto</label>
                                  <i class="material-icons prefix">search</i>
                            </div>
                          
                          <div class="col s1"></div>
                          
                          <div class="input-field col s3">
                              <select id="filtro" onchange="filtrar()">
                                  <option value="" disabled selected>Filtro</option>
                                  <option value="">Todos</option>
                                  <%
                                      for (TipoProduto tp : listTipo) {
                                  %>
                                  <option value="<%= tp.getNome() %>"><%= tp.getNome() %></option>
                                  <%
                                      }
                                  %>
                                </select>
                          </div>
                          
                      </div>
                  </div>
                <%  
                    DecimalFormat df = new DecimalFormat("R$ #,##0.00");
                    ArrayList<Produto> listProd = new ArrayList<Produto>();
                    
                    String tipo = (request.getParameter("tipo") != null) ? request.getParameter("tipo") : ""; 

                    try {
                        ProdutoDAO pDAO = new ProdutoDAO();
                        listProd = pDAO.listar(tipo);
                    } catch (Exception e) {
                        out.print("Erro: " + e);
                    }
                %>
                  
                  <div class="row">
                    <%
                        for (Produto p : listProd) {
                    %>
                    <div class="col m4 s12 l3" style="margin: 1% auto">
                        <div class="card" id="card-produto" style="height: 60%">
                            <div class="card-image">
                                <img src="<%= p.getImgPath() %>" width="100" height="200">
                                    <form action="gerenciar_carrinho_comanda.do" method="post">
                                        <input type="hidden" name="id_produto" value="<%= p.getId() %>">
                                        <input type="hidden" name="comanda" value="<%= id %>">
                                        <input type="hidden" name="opc" value="add">
                                        <div class="row">
                                            <div class="input-field col m12 l12 s12">
                                                <input id="qtd" name="qtd" type="number" min="1" value="1" class="center validate" required>
                                                <label for="qtd" class="">Quantidade</label>
                                            </div>
                                        </div>
                                        <button class="btn-floating halfway-fab waves-effect waves-light red"><i class="material-icons">add</i></button>
                                    </form>
                            </div>
                            <div class="card-content">
                                <span class="card-title black-text"><%= p.getNome() %></span>
                                <p><%= p.getDescricao() %></p>
                                <p class="green-text right-align" style="font-weight: bold; font-size: 14pt"><%= df.format(p.getPreco()) %></p>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
              </div>
            </div>
        </main>
                
        <%@include file="includes/rodape.jsp" %>

        <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
        <script src="node_modules/materialize-css/dist/js/materialize.js" type="text/javascript"></script>
        
        <script>            
                 $(document).ready(function() {
                    $('select').formSelect();
                    $('input.autocomplete').autocomplete({
                      data: {
                          <%
                              for (Produto p : listProd) {
                          %>
                            "<%= p.getNome() %>": null,  
                        <%
                            }
                        %>
                      },
                      onAutocomplete: () => {
                            let nome = document.getElementById("autocomplete-input").value;
                            location.href = 'compra_comanda_search.jsp?id=<%= id %>&op=n&nome=' + nome;
                        }
                    });
                  });
            
                <%
                    if (request.getAttribute("message") != null) {
                %>
                    M.toast({
                        html: "<label style='font-size: 12pt' class='white-text'>${message}</label>",
                        classes: "green"
                    });
                <%   
                    }
                    request.setAttribute("message", null);
                %>
                
                function filtrar() {
                    let tipo = document.getElementById("filtro").value;
                    location.href = 'compra_comanda.jsp?id=<%= id %>&op=n&tipo=' + tipo;
                }
                
                function verificaCarrinho(id, comanda) {
                    if (id == 0) {
                        alert('Adicione algum produto ao carrinho!');
                    } else {
                        location.href = 'finalizar_venda_comanda.jsp?id='+comanda;
                    }
                }
        </script>
        
    </body>
</html>
