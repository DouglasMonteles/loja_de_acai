package controle;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Perfil;
import modelo.Usuario;
import modelo.UsuarioDAO;

public class GerenciarUsuario extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet GerenciarUsuario</title>");            
            out.println("</head>");
            out.println("<body>");
            
            try {
                Usuario u = new Usuario();
                Perfil p = new Perfil();
                UsuarioDAO uDAO = new UsuarioDAO();
                
                String tipo = request.getParameter("tipo");
                int id = Integer.parseInt(request.getParameter("id"));
                
                if ("excluir".equals(tipo)) {
                    if (uDAO.excluir(id) == 1) {
                            out.print("<script>alert('Usuário excluido!'); location.href='usuario.jsp'</script>");
                    } else {
                        out.print("<script>alert('Erro ao  excluir usuário! Tente novamente'); location.href='alterar_usuario.jsp'</script>");
                    }
                }
                
                int id_perfil = Integer.parseInt(request.getParameter("id_perfil"));
                String nome = request.getParameter("nome");
                String login = request.getParameter("login");
                String senha = request.getParameter("senha");
                
                u.setNome(nome);
                u.setLogin(login);
                u.setSenha(senha);
                p.setId(id_perfil);
                u.setPerfil(p);
                
                switch(tipo) {
                    case "inserir":
                        
                        if (uDAO.inserir(u) == 1) {
                            out.print("<script>alert('Usuário inserido!'); location.href='usuario.jsp'</script>");
                        } else {
                            out.print("<script>alert('Erro ao  inserir usuário! Tente novamente'); location.href='inserir_usuario.jsp'</script>");
                        }
                        
                        break;
                    
                    case "alterar":
                        u.setId(id);
                        
                        if (uDAO.alterar(u) == 1) {
                            out.print("<script>alert('Usuário alterado!'); location.href='usuario.jsp'</script>");
                        } else {
                            out.print("<script>alert('Erro ao  alterar usuário! Tente novamente'); location.href='alterar_usuario.jsp?id="+ id +"'</script>");
                        }
                        
                        break;
                }
                
            } catch (Exception e) {
                out.print("Erro: " + e.getMessage());
            }
            
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
