-- ==============================================================================
-- PROJECT: Supermarket Data Aggregation using SQL (Adventure Works)
-- MATAKULIAH: Manajemen Basis Data
-- DESCRIPTION: Kumpulan query advanced aggregation (Grouping Sets, Rollup, Cube)
-- ==============================================================================

-- ==========================================
-- D. GROUPING SETS
-- ==========================================

-- 1. Soal: Temukan total penjualan untuk setiap mode pembayaran dan jenis kelamin
SELECT payment_mode_id, gender, SUM(amount) AS total_penjualan
FROM InvoiceDetails
JOIN Customer ON InvoiceDetails.cust_id = Customer.customer_id
GROUP BY GROUPING SETS ((payment_mode_id), (gender));

-- 2. Soal: Hitung rata-rata peringkat yang diberikan oleh pelanggan pria dan wanita
SELECT gender, AVG(rating) AS rata_rata_rating
FROM Feedback
JOIN Customer ON Feedback.cust_id = Customer.customer_id
GROUP BY GROUPING SETS ((gender));

-- 3. Soal: Tentukan total jumlah produk yang dikembalikan untuk setiap kategori dan mode pembayaran
SELECT category_id, payment_mode_id, SUM(quantity) AS total_dikembalikan
FROM ReturnSlip
JOIN Product ON ReturnSlip.product_id = Product.product_id
JOIN InvoiceDetails ON ReturnSlip.inv_id = InvoiceDetails.inv_id
GROUP BY GROUPING SETS ((category_id), (payment_mode_id));

-- 4. Soal: Temukan total penjualan untuk setiap jenis tawaran dan tipe pelanggan
SELECT offers_type, type_name, SUM(amount) AS total_penjualan
FROM OfferDetails
JOIN PaymentMode ON OfferDetails.offers_id = PaymentMode.offer_id
JOIN InvoiceDetails ON PaymentMode.payment_mode_id = InvoiceDetails.payment_mode_id
JOIN Customer ON InvoiceDetails.cust_id = Customer.customer_id
JOIN CustomerType ON Customer.customer_type_id = CustomerType.type_id
GROUP BY GROUPING SETS ((offers_type), (type_name));

-- 5. Soal: Berapa total penjualan yang terjadi pada setiap tanggal?
SELECT InvoiceDetails.inv_date, SUM(InvoiceDetails.amount) AS total_penjualan
FROM InvoiceDetails
GROUP BY GROUPING SETS ((InvoiceDetails.inv_date), ());


-- ==========================================
-- E. GROUPING FUNCTION & STANDARD AGGREGATION
-- ==========================================

-- 1. Soal: Berapa total pembelian (jumlah produk dibeli) dari setiap invoice?
SELECT invoice_id, SUM(quantity) AS total_pembelian
FROM Buys
GROUP BY invoice_id;

-- 2. Soal: Berapa jumlah produk yang terjual untuk setiap kategori?
SELECT c.category_id, c.category_name, SUM(b.quantity) AS total_terjual
FROM Category c
JOIN Product p ON c.category_id = p.category_id
JOIN Buys b ON p.product_id = b.product_id
GROUP BY c.category_id, c.category_name;

-- 3. Soal: Hitung rata-rata rating yang diberikan oleh setiap pelanggan dalam feedback
SELECT cust_id, AVG(rating) AS rata_rata_rating
FROM Feedback
GROUP BY cust_id;

-- 4. Soal: Berapa total penjualan (jumlah produk terjual) dari setiap karyawan (cashier)?
SELECT cashier_id, SUM(quantity) AS total_penjualan
FROM InvoiceDetails i
JOIN Buys b ON i.inv_id = b.invoice_id
GROUP BY cashier_id;

-- 5. Soal: Berapa total harga beli dan harga jual dari setiap produk?
SELECT product_id, SUM(cost_price) AS total_harga_beli, SUM(selling_price) AS total_harga_jual
FROM Product
GROUP BY product_id;


-- ==========================================
-- F. ROLL UP
-- ==========================================

-- 1. Soal: Temukan pelanggan paling favorit tiap tahunnya (sering berbelanja)
SELECT cust_id, customer_name,
       EXTRACT(YEAR FROM inv_date) AS Invoice_Year,
       SUM(amount) AS Total_Amount
FROM invoicedetails
JOIN customer ON (invoicedetails.cust_id = customer.customer_id)
GROUP BY ROLLUP(cust_id, EXTRACT(YEAR FROM inv_date), customer_name)
ORDER BY Invoice_Year;

-- 2. Soal: Cantumkan id produk dan jumlah produk yang dijual dengan penawaran OFF10
SELECT product_id,
       COUNT(product_id),
       SUM(quantity) AS quan_max
FROM buys
NATURAL JOIN product
WHERE offer_id = 'OFF10'
GROUP BY ROLLUP(product_id)
ORDER BY SUM(quantity) DESC;

-- 3. Soal: Cantumkan ID penawaran dan jumlah produk berdasarkan penawaran yang dikembalikan!
SELECT COALESCE(offer_id, 'Total') AS offer_id,
       SUM(quantity) AS total_quantity
FROM returnslip
NATURAL JOIN product
GROUP BY ROLLUP(offer_id)
HAVING GROUPING(offer_id) = 0 OR GROUPING(offer_id) = 1;

-- 4. Soal: Jumlah produk yang dibeli untuk setiap penawaran produk!
SELECT offer_id, product_id,
       COUNT(product_id) AS Total_Products,
       SUM(quantity) AS Total_Quantity
FROM buys
NATURAL JOIN product
GROUP BY ROLLUP(offer_id, product_id)
ORDER BY offer_id, Total_Quantity DESC;

-- 5. Soal: Menampilkan total jumlah pembelian dari setiap type customer supermarket!
SELECT customertype,
       SUM(amount) AS total_purchase
FROM customertype
JOIN customer ON customertype.type_id = customer.customer_type_id
JOIN invoicedetails ON customer.customer_id = invoicedetails.cust_id
GROUP BY ROLLUP(customertype);


-- ==========================================
-- G. CUBE
-- ==========================================

-- 1. Soal: Tampilkan nama pelanggan beserta jumlah total pembelian yang telah dilakukan
SELECT customer_name,
       block_id,
       SUM(quantity) AS total_pembelian_produk
FROM customer
JOIN invoicedetails id ON customer_id = cust_id
JOIN buys ON inv_id = invoice_id
JOIN block ON block_id = block_id
GROUP BY CUBE(customer_name, block_id);

-- 2. Soal: Tampilkan total penjualan produk untuk semua kategori produk dan jumlahkan semua total penjualan
SELECT category_name,
       SUM(quantity) AS total_penjualan
FROM buys
JOIN invoicedetails ON invoicedetails.inv_id = buys.invoice_id
JOIN product ON product.product_id = buys.product_id
JOIN category ON category.category_id = product.category_id
JOIN block ON block_id = block_id
JOIN customer ON customer.customer_id = invoicedetails.cust_id
GROUP BY CUBE(category_name);

-- 3. Soal: Tampilkan total penjualan (amount) dan jumlah produk yang dibeli berdasarkan tipe pelanggan dan kategori dari tipe pelanggan ‘Silver’ lalu jumlahkan total penjualan dan jumlah produk yang dibeli
SELECT type_name AS customer_type,
       category_name,
       SUM(amount) AS total_penjualan,
       SUM(quantity) AS jumlah_produk_dibeli
FROM invoicedetails
JOIN buys ON inv_id = invoice_id
JOIN customer ON cust_id = customer_id
JOIN customertype ON customer_type_id = type_id
JOIN product ON product.product_id = buys.product_id
JOIN category ON category.category_id = product.category_id
WHERE type_name = 'Silver'
GROUP BY CUBE(type_name, category_name);

-- 4. Soal: Tampilkan tanggal faktur, jenis produk, tipe pelanggan, total penjualan (amount) dan jumlah produk yang dibeli (quantity) berdasarkan tanggal faktur ‘2017-01-15’
SELECT inv_date, product_type, type_name,
       SUM(amount) AS total_sales, 
       SUM(quantity) AS total_quantity
FROM invoicedetails
JOIN buys ON buys.invoice_id = invoicedetails.inv_id
JOIN product ON buys.product_id = product.product_id
JOIN customer ON customer.customer_id = invoicedetails.cust_id
JOIN customertype ON customertype.type_id = customer.customer_type_id
WHERE inv_date = '2017-01-15'
GROUP BY CUBE(inv_date, product_type, type_name);

-- 5. Soal: Hitung jumlah produk yang ada di dalam gudang ‘GWAR’ dan tampilkan tipe produk, nama blok, dan gudang
SELECT warehouse_name,
       block_name,
       product_type,
       COUNT(product_id) AS jumlah_produk_di_gudang
FROM warehouse
LEFT JOIN block ON warehouse_no = warehouse_no
LEFT JOIN product ON block_id = block_id
WHERE warehouse_name = 'GWAR'
GROUP BY CUBE(warehouse_name, block_name, product_type);