class Api::V1::TransactionsController < Api::ApiController
  def index
    authorize Transaction, :index?
    transactions = list(Transaction)
    render_success({ transactions: serializer(transactions) })
  end

  def show
    authorize Transaction, :show?
    transaction = Transaction.find(params[:id])
    render_success({ transaction: serializer(transaction) })
  end
end
