import Table from "react-bootstrap/Table";
import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import axios from "axios";
import { API_DOMAIN } from "../../env.config";

function PolicyList() {
  const [data, setData] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get(API_DOMAIN + "/policy/admin?isProcessed=false");
        if (response.status === 200) {
          setData(response.data.data); // 응답 데이터를 상태에 저장
        } else {
          console.error("Failed to fetch policy data");
        }
      } catch (error) {
        console.error("Error fetching policy data:", error);
      }
    };

    fetchData(); // fetchData 함수 실행
  }, []);

  useEffect(() => {
    console.log("정책데이터:", data);
  }, [data]);

  return (
    <Table striped bordered hover>
      <thead>
        <tr>
          <th>#</th>
          <th>정책 ID</th>
          <th>정책 이름</th>
          <th>가공 여부</th>
        </tr>
      </thead>
      <tbody>
        {data.map((policy, index) => (
          <tr key={policy.policyId}>
            <td>{index + 1}</td>
            <td>{policy.policyId}</td>
            <td>
              <Link to={`modify/${policy.policyId}`} className="text-dark text-decoration-none">
                {policy.policy_name}
              </Link>
            </td>
            <td>{policy.processed ? "Yes" : "No"}</td>
          </tr>
        ))}
      </tbody>
    </Table>
  );
}

export default PolicyList;
