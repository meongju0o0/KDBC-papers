import fs from 'fs';
import path from 'path';
import multer from 'multer';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const uploadDir = path.resolve(__dirname, '../uploads/papers');
fs.mkdirSync(uploadDir, { recursive: true });

const storage = multer.diskStorage({
  destination: (_req, _file, callback) => {
    callback(null, uploadDir);
  },
  filename: (_req, file, callback) => {
    const safeName = file.originalname.replace(/\s+/g, '-').replace(/[^a-zA-Z0-9._-]/g, '');
    callback(null, `${Date.now()}-${safeName}`);
  },
});

const uploader = multer({
  storage,
  limits: { fileSize: 100 * 1024 * 1024 },
  fileFilter: (_req, file, callback) => {
    const isPdf = file.mimetype === 'application/pdf' || file.originalname.toLowerCase().endsWith('.pdf');
    if (!isPdf) {
      callback(new Error('PDF 파일만 업로드할 수 있습니다.'));
      return;
    }

    callback(null, true);
  },
});

export function uploadPaperPdf(req, res, next) {
  const upload = uploader.single('pdf');

  upload(req, res, (error) => {
    if (error) {
      if (error instanceof multer.MulterError && error.code === 'LIMIT_FILE_SIZE') {
        return res.status(400).json({ message: '파일 크기는 최대 100MB까지 업로드할 수 있습니다.' });
      }

      return res.status(400).json({ message: error.message });
    }

    return next();
  });
}
