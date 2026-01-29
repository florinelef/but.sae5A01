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
        <title>${appTitle} - <fmt:message key="label.account"/></title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="/style.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="icon" type="image/png" href="${appFavicon}">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <header>
        <!-- NAVBAR -->
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

    <!-- TITRE -->
            <h2 class="mb-4"><fmt:message key="label.personal_space"/> ${user.firstname} ${user.lastname}</h2>

            <div class="row g-4">

                <!-- INFORMATIONS UTILISATEUR -->
                <div class="col-lg-6">
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white">
                            <fmt:message key="label.account_info"/>
                        </div>
                        <div class="card-body">
                            <form:form action="update_user" method="post">

                                <div class="row g-3" style="max-width: 600px;">
                                    <div class="col-md-6">
                                        <label class="form-label"><fmt:message key="label.lastname"/></label>
                                        <input type="text" class="form-control" name="lastname" value="${user.lastname}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label"><fmt:message key="label.firstname"/></label>
                                        <input type="text" class="form-control" name="firstname" value="${user.firstname}">
                                    </div>

                                    <input type="hidden" name="login" value="${user.login}" readonly>

                                    <div class="col-md-6">
                                        <label class="form-label"><fmt:message key="label.email"/></label>
                                        <input type="email" class="form-control" name="email" value="${user.email}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label"><fmt:message key="label.password"/></label>
                                        <input type="password" class="form-control" name="password" placeholder="*******">
                                    </div>
                                </div>


                                <div class="mt-3">
                                    <button class="btn btn-success">
                                        <fmt:message key="label.update"/>
                                    </button>
                                </div>
                            </form:form>

                            <div class="mb-3 mt-3">
                                <label class="form-label d-block"><fmt:message key="label.profile_pic"/></label>

                                <div class="d-flex align-items-center mb-3">
                                    <c:choose>
                                        <c:when test="${not empty user.img_path}">
                                            <img src="${user.img_path}" class="rounded-circle border border-2 shadow-sm" style="width: 80px; height: 80px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="rounded-circle bg-primary text-white d-flex justify-content-center align-items-center" 
                                                style="width:80px; height:80px; font-size:1.4rem; font-weight:600;">
                                                ${fn:substring(user.firstname, 0, 1)}${fn:substring(user.lastname, 0, 1)}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <span class="ms-3 text-muted"><fmt:message key="label.current_pic"/></span>
                                </div>

                                <form:form action="/update_user/upload" method="post" enctype="multipart/form-data">
                                    <div class="input-group">
                                        <input type="file" class="form-control" name="file" id="fileUpload" accept="image/*" required>
                                        
                                        <button class="btn btn-primary" type="submit">
                                            <i class="bi bi-cloud-upload me-2"></i> <fmt:message key="label.upload"/>
                                        </button>
                                    </div>
                                    <div class="form-text"><fmt:message key="label.accepted_formats"/> : JPG, PNG, GIF. <fmt:message key="label.max_size"/> : 2MB.</div>
                                </form:form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECTION RDV PASSES -->
                <div class="col-lg-6">
                    <div class="card shadow-sm">
                        <div class="card-header bg-secondary text-white">
                            <fmt:message key="label.past_events"/>
                        </div>
                        <div class="card-body">
                            <c:if test="${empty pastBookings}">
                            <p class="text-muted"><fmt:message key="label.no_past_events"/></p>
                        </c:if>

                        <c:if test="${not empty pastBookings}">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th><fmt:message key="label.date"/></th>
                                        <th><fmt:message key="label.slot"/></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="booking" items="${pastBookings}" varStatus="loop">
                                    <c:if test="${loop.index < limit}">
                                        <tr>
                                            <td>${dp:formatDate(booking.slot.dayStart, sessionScope.lang)}</td>
                                            <td>${booking.slot.timeStart} - ${booking.slot.timeEnd}</td>
                                             <td>
                                                <a class="btn btn-sm btn-primary me-2" href="documents?idSlot=${booking.id.idSlot}&login=${booking.id.login}&lastPage=compte"><fmt:message key="label.documents"/></a>
                                            </td>
                                        </tr>
                                        
                                    </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                        <a class="link" href="compte?limit=${limit+5}"><fmt:message key="label.see_more"/> <i class="bi bi-plus-circle"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- RENDEZ-VOUS À VENIR -->
            <div class="card shadow-sm mt-5">
                <div class="card-header bg-info text-white">
                    <fmt:message key="label.upcoming_events"/>
                </div>
                <div class="card-body">

                        <c:if test="${empty bookings}">
                            <p class="text-muted"><fmt:message key="label.no_upcoming_events"/></p>
                        </c:if>

                        <c:if test="${not empty bookings}">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th><fmt:message key="label.date"/></th>
                                        <th><fmt:message key="label.slot"/></th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="booking" items="${bookings}">
                                        <tr>
                                            <td>${dp:formatDate(booking.slot.dayStart, sessionScope.lang)}</td>
                                            <td>${booking.slot.timeStart} - ${booking.slot.timeEnd}</td>
                                            <td>
                                                <form:form action="cancel_booking" method="post">
                                                    <input type="hidden" name="idSlot" value="${booking.id.idSlot}">
                                                    <input type="hidden" name="login" value="${booking.id.login}">
                                                    <button class="btn btn-sm btn-danger">
                                                        <fmt:message key="label.cancel"/>
                                                    </button>
                                                </form:form>

                                            </td>
                                            <td>
                                                <a class="btn btn-sm btn-primary me-2" href="documents?idSlot=${booking.id.idSlot}&login=${booking.id.login}&lastPage=compte"><fmt:message key="label.documents"/></a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>

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
