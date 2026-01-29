<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="dp" uri="http://fr.but3.sae_web/dateparser" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${(empty sessionScope.lang) ? 'fr': sessionScope.lang}"/>

<fmt:setBundle basename="messages"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8">
        <title>${appTitle} - <fmt:message key="label.documents"/></title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="/style.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="icon" type="image/png" href="${appFavicon}">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <header>
        <nav class="navbar navbar-expand bg-light">
            <div class="container-fluid">
                <span class="navbar-brand">
                    <img src="${appFavicon}" width="32px">
                    ${appTitle}
                </span>
                
                <div class="collapse navbar-collapse" id="navbarContent">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="planning"><fmt:message key="label.planning"/></a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link" href="compte"><fmt:message key="label.account"/></a>
                        </li>

                    <c:if test="${role == 'admin'}">
                        <li class="nav-item">
                            <a class="nav-link" href="panel_admin"><fmt:message key="label.admin_panel"/></a>
                        </li>
                    </c:if>
                    </ul>

                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <form:form action="/logout" method="post">
                                <c:if test="${_csrf != null}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                </c:if>
                                <button class="btn btn-outline-danger"><fmt:message key="label.logout"/></button>
                            </form:form>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>
    
    <body>
        <div class="container my-5">
            
            <c:if test="${lastPage == 'compte'}">
                <a href="/${lastPage}" class="btn btn-outline-secondary mb-4">
                    <i class="bi bi-arrow-left"></i> <fmt:message key="label.go_back"/>
                </a>
            </c:if>
            <c:if test="${lastPage != 'compte'}">
                <form:form action="${lastPage}" method="post" class="col">
                    <input type="hidden" name="id_slot" value="${idSlot}">
                    <button type="submit" class="btn btn-outline-secondary mb-4">
                        <i class="bi bi-arrow-left"></i> <fmt:message key="label.go_back"/>
                    </button>
                </form:form>
            </c:if>

            <div class="card shadow-sm mb-5">
                <div class="card-header bg-info text-white">
                    <h3 class="my-1"><i class="bi bi-calendar-check me-2"></i> <fmt:message key="label.booking_of"/> ${dp:formatDate(booking.slot.dayStart, sessionScope.lang)}</h3>
                </div>
                <div class="card-body">
                    <p class="mb-0">
                        <strong><fmt:message key="label.slot"/> :</strong> ${booking.slot.timeStart} - ${booking.slot.timeEnd}<br>
                    </p>
                </div>
            </div>

            <div class="row g-4">
                
                <div class="col-lg-7">
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white">
                            <i class="bi bi-list-columns-reverse me-2"></i> <fmt:message key="label.related_docs"/>
                        </div>
                        <div class="card-body">
                            <c:if test="${empty documents}">
                                <p class="alert alert-warning"><fmt:message key="label.no_docs_found"/></p>
                            </c:if>

                            <c:if test="${not empty documents}">
                                <p class="text-muted"><fmt:message key="label.click_to_download"/></p>
                                <ul class="list-group">
                                    <c:forEach var="doc" items="${documents}">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            
                                            <a href="${doc.docPath}" target="_blank" class="text-decoration-none text-primary">
                                                <i class="bi bi-file-arrow-down-fill me-2"></i> 
                                                ${fn:substringAfter(doc.docPath, '/documents/')}
                                            </a>
                                            
                                            <form:form action="/documents/delete" method="post" class="ms-3">
                                                <input type="hidden" name="idDoc" value="${doc.idDoc}">
                                                <input type="hidden" name="idSlot" value="${booking.id.idSlot}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Supprimer">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form:form>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:if>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="card shadow-sm">
                        <div class="card-header bg-success text-white">
                            <i class="bi bi-cloud-upload me-2"></i> <fmt:message key="label.upload_doc"/>
                        </div>
                        <div class="card-body">
                            
                            <form:form action="/documents/upload" method="post" enctype="multipart/form-data">
                                <div class="mb-3">
                                    <label for="documentUpload" class="form-label"><fmt:message key="label.select_file"/></label>
                                    <input type="file" class="form-control" name="file" id="documentUpload" required>
                                </div>
                                
                                <input type="hidden" name="idSlot" value="${booking.id.idSlot}">
                                <input type="hidden" name="login" value="${booking.id.login}">
                                
                                <input type="hidden" name="redirectUrl" value="/documents?login=${booking.id.login}&idSlot=${booking.id.idSlot}"> 
                                
                                <div class="d-grid">
                                    <button class="btn btn-success" type="submit">
                                        <i class="bi bi-upload"></i> <fmt:message key="label.upload"/>
                                    </button>
                                </div>
                                <div class="form-text mt-3"><fmt:message key="label.info_doc"/></div>
                            </form:form>
                        </div>
                    </div>
                </div>

            </div>

        </div>

        <footer class="fixed-bottom bg-light">
            <div class="d-flex justify-content-between border-top p-3">
                <span>${appTitle} &copy;</span>
                <span>Florine Lefebvre & Charlie Darques</span>
            </div>
        </footer>
    </body>
</html>