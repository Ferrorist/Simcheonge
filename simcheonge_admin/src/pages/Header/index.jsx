import { useNavigate } from "react-router-dom";
import Container from "react-bootstrap/Container";
import Navbar from "react-bootstrap/Navbar";
import "bootstrap/dist/css/bootstrap.min.css";

function TopBar() {
  const navigate = useNavigate();

  const handleLoginClick = () => {
    navigate("/loginPage");
  };

  return (
    <Navbar className="bg-body-tertiary">
      <Container>
        <Navbar.Brand href="#home">심청이 관리자 페이지</Navbar.Brand>
        <Navbar.Toggle />
        <Navbar.Collapse className="justify-content-end">
          <Navbar.Text>
            Signed in as:{" "}
            <a href="#login" onClick={handleLoginClick}>
              admin
            </a>
          </Navbar.Text>
        </Navbar.Collapse>
      </Container>
    </Navbar>
  );
}

export default TopBar;
