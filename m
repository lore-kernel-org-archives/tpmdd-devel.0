From: Martin Galvan <omgalvan.86-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Reading from /sys/class/tpm/tpmX/device/pcrs
Date: Tue, 20 Mar 2018 17:13:01 -0300
Message-ID: <CAN19L9HeGMZ7hO0+tqq_F7Xv+wnGbdjW=rLx=b-pP5ZJvN4w8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-TtF/mJH4Jtrk1uMJSBkQmQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi all,

Documentation/ABI/stable/sysfs-class-tpm says the following about
/sys/class/tpm/tpmX/device/pcrs:

"The "pcrs" property will dump the current value of all Platform
Configuration Registers in the TPM. Note that since these values may
be constantly changing, the output is only valid for a snapshot in
time."

Does this mean that if I read this file line-by-line through a
stream-like API (such as std::ifstream) I could potentially end up
with reg values from different moments in time? E.g. the PCR-00 value
will correspond to time T0, PCR-01 will correspond to time T1, end so
on.

Would it be safer to make a copy of the file first, or could this have
the same issue?

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
