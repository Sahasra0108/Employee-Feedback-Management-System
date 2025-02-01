import React, { useEffect, useState } from "react";
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  TablePagination,
} from "@mui/material";

import { getfeedbacks } from "../api/api";

function Feedbacktable() {
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(3);
  const [feedbackData, setFeedbackData] = useState([]);
  const [searchValue, setSearchValue] = useState([]);

  useEffect(() => {
    getfeedbacks()
      .then((data) => setFeedbackData(data))
      .catch((error) => console.error("Error fetching feedbacks", error));
  }, []);

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const filteredTeamlead = feedbackData.filter((row) =>
    row.teamLead
      .toString()
      .toLowerCase()
      .includes(searchValue.toString().toLowerCase())
  );

  return (
    <Paper className="p-20">
      <input
        type="text"
        placeholder="Search Team Lead"
        value={searchValue}
        onChange={(e) => setSearchValue(e.target.value)}
        className="input"
      />

      <TableContainer className="Table">
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>
                <b>Employee Name</b>
              </TableCell>
              <TableCell>
                <b>Team Lead</b>
              </TableCell>
              <TableCell>
                <b>Feedback</b>
              </TableCell>
              <TableCell>
                <b>Rating</b>
              </TableCell>
              <TableCell>
                <b>Submission Date</b>
              </TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredTeamlead
              .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
              .map((row) => (
                <TableRow key={row.id}>
                  <TableCell>{row.employeeName}</TableCell>
                  <TableCell>{row.teamLead}</TableCell>
                  <TableCell>{row.feedback}</TableCell>
                  <TableCell>{row.rating}</TableCell>
                  <TableCell>
                    {Object.values(row.submittedDate).join("-")}
                  </TableCell>
                </TableRow>
              ))}
          </TableBody>
        </Table>
      </TableContainer>
      {/* Pagination Controls */}
      <TablePagination
        component="div"
        count={feedbackData.length}
        page={page}
        onPageChange={handleChangePage}
        rowsPerPage={rowsPerPage}
        onRowsPerPageChange={handleChangeRowsPerPage}
      />
    </Paper>
  );
}

export default Feedbacktable;
