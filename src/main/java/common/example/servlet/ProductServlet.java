package common.example.servlet;

import common.example.model.Product;
import common.example.dao.ProductDAOMySQL;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        boolean isAdmin = "admin".equals(role);
        
        if ("getDetail".equals(action)) {
            response.setContentType("application/json;charset=UTF-8");
            handleGetProductDetail(request, response);
            return;
        }
        
        if (isAdmin && "admin_data".equals(action)) {
            response.setContentType("application/json;charset=UTF-8");
            handleAdminRequest(request, response);
            return;
        }
        
        response.setContentType("application/json;charset=UTF-8");
        
        String keyword = request.getParameter("keyword");
        if (keyword != null && !keyword.trim().isEmpty()) {
            Map<String, Object> searchResult = ProductDAOMySQL.searchProductsWithResult(keyword.trim());
            String json = convertSearchResultToJson(searchResult, keyword);
            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();
            return;
        }
        
        String category = request.getParameter("category");
        if (category == null || category.trim().isEmpty()) category = "phone";
        
        List<Product> products = ProductDAOMySQL.getProductsByCategory(category);
        String json = convertProductsToJson(products, category, isAdmin);
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        if (!"admin".equals(role)) {
            PrintWriter out = response.getWriter();
            out.print("{\"success\":false,\"error\":\"权限不足\"}");
            out.flush();
            return;
        }
        
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            handleAddProduct(request, response);
        } else if ("update".equals(action)) {
            handleUpdateProduct(request, response);
        } else if ("delete".equals(action)) {
            handleDeleteProduct(request, response);
        } else {
            PrintWriter out = response.getWriter();
            out.print("{\"success\":false,\"error\":\"未知操作\"}");
            out.flush();
        }
    }
    
    private void handleGetProductDetail(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String productId = request.getParameter("productId");
        if (productId == null || productId.trim().isEmpty()) {
            PrintWriter out = response.getWriter();
            out.print("{\"success\":false,\"message\":\"商品ID不能为空\"}");
            out.flush();
            return;
        }
        
        Product product = ProductDAOMySQL.getProductById(productId);
        PrintWriter out = response.getWriter();
        if (product != null) {
            StringBuilder json = new StringBuilder();
            json.append("{\"success\":true,\"product\":{");
            json.append("\"id\":\"").append(escapeJson(product.getId())).append("\",");
            json.append("\"name\":\"").append(escapeJson(product.getName())).append("\",");
            json.append("\"category\":\"").append(escapeJson(product.getCategory())).append("\",");
            json.append("\"icon\":\"").append(escapeJson(product.getIcon() != null ? product.getIcon() : "")).append("\",");
            json.append("\"price\":").append(product.getPrice());
            json.append("}}");
            out.print(json.toString());
        } else {
            out.print("{\"success\":false,\"message\":\"商品不存在\"}");
        }
        out.flush();
    }
    
    private void handleAdminRequest(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String category = request.getParameter("category");
        if (category == null || category.trim().isEmpty()) category = "phone";
        
        List<Product> products = ProductDAOMySQL.getProductsByCategory(category);
        String json = convertProductsToJson(products, category, true);
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }
    
    private void handleAddProduct(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String icon = request.getParameter("icon");
        String priceStr = request.getParameter("price");
        
        try {
            double price = Double.parseDouble(priceStr);
            Product product = new Product(id, name, category, icon, price);
            boolean success = ProductDAOMySQL.addProduct(product);
            PrintWriter out = response.getWriter();
            if (success) {
                out.print("{\"success\":true,\"message\":\"商品添加成功\"}");
            } else {
                out.print("{\"success\":false,\"error\":\"商品ID已存在或参数错误\"}");
            }
            out.flush();
        } catch (Exception e) {
            PrintWriter out = response.getWriter();
            out.print("{\"success\":false,\"error\":\"参数格式错误\"}");
            out.flush();
        }
    }
    
    private void handleUpdateProduct(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String productId = request.getParameter("productId");
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String icon = request.getParameter("icon");
        
        try {
            Double price = priceStr != null ? Double.parseDouble(priceStr) : null;
            boolean success = ProductDAOMySQL.updateProduct(productId, name, price, icon);
            PrintWriter out = response.getWriter();
            if (success) {
                out.print("{\"success\":true,\"message\":\"商品更新成功\"}");
            } else {
                out.print("{\"success\":false,\"error\":\"商品不存在\"}");
            }
            out.flush();
        } catch (Exception e) {
            PrintWriter out = response.getWriter();
            out.print("{\"success\":false,\"error\":\"参数格式错误\"}");
            out.flush();
        }
    }
    
    private void handleDeleteProduct(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String productId = request.getParameter("productId");
        boolean success = ProductDAOMySQL.deleteProduct(productId);
        PrintWriter out = response.getWriter();
        if (success) {
            out.print("{\"success\":true,\"message\":\"商品删除成功\"}");
        } else {
            out.print("{\"success\":false,\"error\":\"商品不存在\"}");
        }
        out.flush();
    }
    
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
    
    private String convertProductsToJson(List<Product> products, String category, boolean isAdmin) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"category\":\"").append(category).append("\",");
        json.append("\"products\":[");
        
        for (int i = 0; i < products.size(); i++) {
            Product product = products.get(i);
            json.append("{");
            json.append("\"id\":\"").append(product.getId()).append("\",");
            json.append("\"name\":\"").append(product.getName()).append("\",");
            json.append("\"icon\":\"").append(product.getIcon()).append("\",");
            json.append("\"price\":").append(product.getPrice());
            
            if (isAdmin) {
                int orderCount = ProductDAOMySQL.getProductOrderCount(product.getId());
                json.append(",\"orderCount\":").append(orderCount);
            }
            
            json.append("}");
            if (i < products.size() - 1) json.append(",");
        }
        
        json.append("]}");
        return json.toString();
    }
    
    @SuppressWarnings("unchecked")
    private String convertSearchResultToJson(Map<String, Object> searchResult, String keyword) {
        StringBuilder json = new StringBuilder();
        boolean found = (boolean) searchResult.get("found");
        List<Map<String, Object>> products = (List<Map<String, Object>>) searchResult.get("products");
        
        json.append("{");
        json.append("\"keyword\":\"").append(keyword).append("\",");
        json.append("\"found\":").append(found).append(",");
        json.append("\"count\":").append(products.size()).append(",");
        json.append("\"products\":[");
        
        for (int i = 0; i < products.size(); i++) {
            Map<String, Object> product = products.get(i);
            json.append("{");
            json.append("\"id\":\"").append(product.get("id")).append("\",");
            json.append("\"name\":\"").append(product.get("name")).append("\",");
            json.append("\"icon\":\"").append(product.get("icon")).append("\",");
            json.append("\"price\":").append(product.get("price")).append(",");
            json.append("\"category\":\"").append(product.get("category")).append("\"");
            json.append("}");
            if (i < products.size() - 1) json.append(",");
        }
        
        json.append("]}");
        return json.toString();
    }
}
