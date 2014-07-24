<%@ Page language="c#" Codebehind="Login.aspx.cs" AutoEventWireup="False" Inherits="Revelation.LoginForm" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Welcome to Synergy!</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
		<link rel="stylesheet" href="schemes/login.css"/>
        <link rel="Shortcut Icon" href="synergy.ico">
        <script type="text/javascript" src="js/REVELATION/jquery-1.8.3.min.js"></script>
        <script type="text/javascript">
            // Tries to open a window and showsw a message if we can't
            // Returns true if there is a popup blocker
            function DetectPopupBlocker() {
                var myTest;
                var res = false;
                myTest = window.open("about:blank", "", "directories=no,height=100,width=100,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,top=0,location=no");

                if (!myTest) {
                    res = true;
                }
                else {
                    myTest.close();
                }
                return res;
            } //DetectPopupBlocker

            function ManualPopup() {
                var popupSpan;
                if (DetectPopupBlocker()) {
                    alert('A popup blocker has been detected');
                    popupSpan = document.getElementById("POPUP_ERROR");
                    popupSpan.style.display = "block";
                }
                else {
                    alert('No popup blocker has been detected');
                }

                return false;
            } //ManualPopup

            // Displays a message if the popup blocker is detected
            function DetectPopupBlockerOnLoad() {
                var popupSpan;
                if (CheckForPopup('RT_POPUP')) {
                    if (DetectPopupBlocker()) {
                        popupSpan = document.getElementById("POPUP_ERROR");
                        popupSpan.style.display = "block";
                    }
                    else {
                        CreateCookie('RT_POPUP', 1, 1);
                    }
                }
                return false;
            } //DetectPopupBlockerOnLoad

            function AddFavorite() {
                if (window.external) {
                    window.external.Addfavorite(window.location.href, document.title)
                }
                else {
                    alert("I'm sorry, your browser does not support adding to favorties.  Please refer to your browser's help file " +
					"to learn how to book mark a page.");
                }

                return false;
            } //AddFavorite

            // Returns true if we need to check for a popup
            function CheckForPopup(name) {
                var res = true;
                if (document.cookie.length > 0) {
                    c_start = document.cookie.indexOf(name + "=");
                    if (c_start != -1) {
                        res = false;
                    }
                }
                return res;

            } //CheckForPopup

            // Creates a cookie
            function CreateCookie(name, value, days) {
                var exdate = new Date(); exdate.setDate(exdate.getDate() + days);
                document.cookie = name + "=" + escape(value) +
                ((days == null) ? "" : ";expires=" + exdate.toGMTString());
            } //CreateCookie

            $(window).load(function () {
                // Center the content horizontally and vertically,
                // minus the footer
                var $table = $('body > form > table').show();

                $(window).on('resize', function (ev) {
                    $table.css("position", "absolute");

                    var footerHeight = $('#Footer').outerHeight();
                    
                    // ensure the window scrolls past the footer.
                    $table.css('padding-bottom', footerHeight + 'px');

                    var topPos = (($(window).height() - $table.outerHeight()) / 2) +
                                   $(window).scrollTop();

                    // center the table
                    $table.css("top", Math.max(0, topPos) + "px");
                    $table.css("left", Math.max(0, (($(window).width() - $table.outerWidth()) / 2) +
                                                $(window).scrollLeft()) + "px");
                }).trigger('resize');

                $table.hide().fadeIn({
                    duration: 250,
                    complete: function () {
                        $('#login_name').focus();
                    }
                });
            });
        </script>
			
	</head>
	<body onLoad="DetectPopupBlockerOnLoad()">
        <form id="Login" method="post" runat="server">
		<table align="center" style="display: none">
			<tr>
				<td width="400" valign="middle">
					<table id="PRODUCT_TABLE" runat="server">
					</table>
                </td>

				<td width="400" valign="bottom">
					<div id="LOGO" runat="server"></div>
					<div class=""><!-- APS COMMENT Don Jarrett 7/21/2014 Please enter your login name and password<br/>
							below to access the application. //--></div>
								
                    <div class="input-group">
						<label for="login_name">Login Name</label>
						<input style="WIDTH:64%" type="text" size="35" id="login_name" name="login_name" value="" autocomplete="OFF"/>
                    </div>

                    <div class="input-group" >
						<label for="password">Password</label>
						<input style="WIDTH:64%" type="password" size="35" name="password" value="" autocomplete="OFF"/>
                    </div>

					<div class="input-group" runat="server" id="DNDIV">
						<label for="DN">Select District</label>
						<asp:DropDownList id="DN" runat="server" Width="64%"></asp:DropDownList>
					</div>
                </td>
            </tr>
            <tr>
				<td valign="top">
					<img onclick="ManualPopup();" src="Images/Revelation/Edupoint_logo.png">
				</td>

                <td valign="top">
                    <div class="input-group">
        				<input type="submit" name="btnLogin" value="Login" class="LOGIN_BUTTON" autocomplete="OFF"/>
                    </div>

                    <asp:PlaceHolder id="SubLoginRedir" runat="server">
                    <a runat="server" id="SubLoginPage" href="LoginSub.aspx">Substitute Teacher Login</a>
                    </asp:PlaceHolder>

					<div id="POPUP_ERROR" class="POPUP_ERROR">A pop up blocker has been detected. Please check your browser and any additional toolbars (like Google or Yahoo) and allow pop ups for this URL.</div>
					<div id="ERROR" runat="server"></div>
                </td>
			</tr>
		</table>
        </form>

        <div id="Footer">
			<!-- APS ADDED By Don Jarrett 7/21/2014 //--><div class="copyright" style="padding-bottom: 5px">By logging into this site, you agree to <a href="https://www.aps.edu/student-information-systems-sis/synergy-terms/" target="_blank" style="text-decoration: underline;">these terms</a>.</div><!-- APS END ADDED //-->
            <span id="ContactUsSpacer" runat="server"><a runat="server" id="ContactUsHref" href="mailto:support@edupoint.com?subject">Contact Us</a> |</span>
            <a href="#" onclick="ManualPopup()">Check For Popup</a><!-- APS COMMENT Don Jarrett 7/21/2014 |
            <a href="#" onclick="AddFavorite()">Add This Page to My Favorites</a> END APS COMMENT //-->

            <div class="copyright">Copyright © 2002-<% Response.Write (DateTime.Now.Year.ToString());%>  Edupoint Educational Systems. All rights reserved.</div>
        </div>
	</body>
</html>
