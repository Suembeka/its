/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package web.Sync;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import jdk.nashorn.internal.parser.JSONParser;
import org.json.JSONObject;
import sync.AnswererStart;
import sync.AnswererSync;
import sync.Converter;
import sync.Message;
import sync.SyncService;
import sync.SyncSession;

/**
 *
 * @author ksinn
 */
public class SyncServlet extends HttpServlet {

    private static final org.apache.log4j.Logger log = org.apache.log4j.Logger.getLogger(SyncServlet.class.getName());
    static SyncService syncService = new SyncService();
    {
        syncService.setAnswerer(new AnswererStart());
        syncService.setAnswerer(new AnswererSync());
    }
    
    private JSONObject parseRequest(HttpServletRequest request) throws IOException {
        StringBuffer jb = new StringBuffer();
        String line = null;
        try {
            BufferedReader reader = request.getReader();
            while ((line = reader.readLine()) != null) {
                jb.append(line);
            }
                                
            JSONObject jsonObject = new JSONObject(jb.toString());
            return jsonObject;
        } catch (Exception e) {
            log.error(null, e);
            throw e;
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            try {
                Message mes = Converter.toJavaObject(parseRequest(request));
                SyncSession ses = (SyncSession) request.getSession().getAttribute("syncSession");
                if(ses!=null){
                    mes.setSession(ses);
                }
                Message answer = syncService.answer(mes);
                request.getSession().setAttribute("syncSession", answer.getSession());
                JSONObject toJSON = Converter.toJSON(answer);
                response.getWriter().print(toJSON.toString());
            } catch (Exception ex) {
                log.error(null, ex);
                response.sendError(500);
            }
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