# Mioto-Intern

## 1. Các tính năng có trong project:

- **Đăng ký tài khoản bằng Email/Password:** Dữ liệu người dùng sẽ được tạo mặc định vào Firebase database. Mỗi người dùng sau khi đăng khí sẽ có một UID do Google Firebase tự cung cấp.

- **Đăng nhập:** Có thể đăng nhập bằng tài khoản Email đã tạo hoặc bằng tài khoản Facebook. UID của người dùng đăng nhập bằng Facebook sẽ là ID từ tài khoản Facebook (Vì ID của Tài khoản FB chỉ toàn số, trong khi UID của Google Firebase cung cấp bao gồm vừa số và chữ và số lượng có thể cung cấp là quá lớn nên sẽ không có tình trạng trùng UID (tỉ lệ trùng không đáng nói tới)). Thông tin của người dùng sẽ là những thông tin có thể lấy được từ Facebook API. Những thông tin không được phép lấy sẽ do người dùng tự chỉnh sửa. Avatar sẽ lấy URL từ Avatar của Facebook.

- Nếu tài khoản Facebook này đã có trong Database thì sẽ không thực hiện bước ghi đè thông tin lấy từ Facebook, để bảo toàn thông tin mà người dùng đã chỉnh sửa trong Firebase database của project.

- **Xem thông tin cá nhân.**

- **Cập nhật thông tin:** Có thể cập nhật Avatar, Tên người dùng, Ngày tháng năm sinh, Số điện thoại. Avatar sau khi cập nhật sẽ được lưu trên Firebase Storage và thông tin của người dùng trong Database sẽ bao gồm URL đến hình ảnh lưu trong Storage đó.

- **Xem danh sách bạn bè:** Danh sách bạn bè sẽ được lưu trên Database dưới UID của người dùng. Ứng dụng sẽ đọc danh sách UID đó, lấy dữ liệu của người dùng thông qua UID trên Database rồi hiển thị.

## 2. Account test tính năng danh sách bạn bè:

```
Email: test@gmail.com 
Password: 12345678
```

- **Lưu ý khi test**: Vì quá trình load avatar tất cả đều được code dưới dạng tiến trình chạy song song để không làm đứng app trong quá trình load hình ảnh nên nếu avatar chưa hiển thị ngay thì có thể là do tốc độ mạng.
 
→Lúc cập nhật thông tin thì cũng sẽ phải upload avatar lên Firebase storage nên có thể hơi chậm tuỳ thuộc vào tốc độ mạng.

## 3. Những điểm chưa hoàn thành:

- Phải test ngày tháng năm của người dùng cập nhật có hợp lệ không nhưng em chưa làm.
- Giao diện nên đẹp hơn và căn lề để hiển thị đúng trên các đời máy khác nhau. - Lưu trữ và hiển thị thông tin ngày bắt đầu tạo tài khoản.
- Nên có thêm Circular Process Bar trong những lúc load để trải nghiệm người dùng được tốt hơn.

- Vì chỉ mới làm có 4 ngày nên em đã hoàn thành các tính năng chính, còn các bước kiểm tra các lỗi xảy ra từ phía người dùng thì em chưa hoàn thành. Mong anh thông cảm.
