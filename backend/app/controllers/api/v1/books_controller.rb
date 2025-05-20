class Api::V1::BooksController < Api::ApiController
  def index
    authorize Book, :index?
    books = list(Book)
    render_success({ books: serializer(books) })
  end

  def show
    authorize Book, :show?
    book = Book.find(params[:id])
    render_success({ book: serializer(book) })
  end

  def create
    authorize Book, :create?
    book = Book.create!(book_params)
    render_success({ book: serializer(book) }, :created)
  end

  def update
    authorize Book, :update?
    book = Book.find(params[:id])
    book.update!(book_params)
    render_success({ book: serializer(book) })
  end

  def destroy
    authorize Book, :destroy?
    book = Book.find(params[:id])
    book.destroy!
    render_success({ message: "Book deleted successfully" }, :no_content)
  end

  def borrow
    authorize Book, :borrow?
    book = Book.find(params[:book_id])
    user = User.find(params[:user_id])
    if book.quantity <= 0
      return render_error("Book not available", :unprocessable_entity)
    end
    transaction = Transaction.create!(user: user, book: book, transaction_type: :borrow, price: book.borrow_price * params[:days].to_i, transaction_date: Time.current, return_date: Time.current + params[:days].to_i.days)
    book.update!(quantity: book.quantity - 1)
    render_success({ transaction: TransactionSerializer.render(transaction) })
  end

  def buy
    authorize Book, :buy?
    book = Book.find(params[:book_id])
    user = User.find(params[:user_id])
    transaction = Transaction.create!(user: user, book: book, transaction_type: :buy, price: book.buy_price, transaction_date: Time.current)
    book.update!(quantity: book.quantity - 1)
    render_success({ transaction: TransactionSerializer.render(transaction) })
  end

  def return
    authorize Book, :return?
    book = Book.find(params[:book_id])
    transaction = Transaction.find(params[:transaction_id])
    if transaction.return_date < Time.current
      return render_error("Book already returned", :unprocessable_entity)
    end
    transaction.update!(return_date: Time.current)
    book.update!(quantity: book.quantity + 1)
    render_success({ transaction: TransactionSerializer.render(transaction) })
  end

  private

  def book_params
    params.permit(:title, :author,  :isbn, :quantity, :buy_price, :borrow_price)
  end
end
