import { NextRequest, NextResponse } from "next/server";
import { deleteSession } from '@/app/lib/session'
import {redirect} from "next/navigation";

export function POST(req: NextRequest) {
    deleteSession()
    redirect('/')
}